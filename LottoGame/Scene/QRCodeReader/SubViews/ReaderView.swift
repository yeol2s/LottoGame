//
//  ReaderView.swift
//  LottoGame
//
//  Created by 유성열 on 11/24/23.
//

import UIKit
import AVFoundation // AVFoundation 필수

// 뷰컨트롤러에 리더뷰에서 QRCode 인식 성공, 실패에 대한 처리를 위해 status를 열거형으로 관리하고
// 델리게이트를 만들어줌
enum ReaderStatus { // 연관값으로 열거형 선언
    case sucess(_ code: String?)
    case fail
    //case stop(_ isButtonTap: Bool)
    case stop
}
// 리더뷰 델리게이트
protocol ReaderViewDelegate: AnyObject {
    func rederComplete(status: ReaderStatus) // 열거형 status를 가지고 함수 호출
}


// QR 인식하는 뷰
// 카메라 화면을 View에 띄운다 -> QRCode를 인식 부분 이외에 어둡게 처리하고 인식 부분에 테두리 그림 -> 인식되면 데이터 처리
final class ReaderView: UIView {
    weak var delegate: ReaderViewDelegate?
    
    // 카메라 화면 보여주는 Layer
    // AVCaptureVideoPreviewLayer는 'CALayer'의 서브클래스로 카메라나 다른 비디오 입력장치로부터 비디오를 받아와서 화면에 실시간으로 보여줄 때 사용되는 것(카메라 앱을 사용할 때 미리보기 창에 보이는 것과 비슷한 역할)
    // AVCaptureSession는 비디오나 오디오를 촬영하기 위한 준비를 도와주는 것(카메라나 마이크와 같은 장치로부터 데이터를 수집하고, 그 데이터를 활용하여 동영상이나 사진을 찍을 수 있게 해줌)
    // AVCaptureSession는 캡처할 미디어의 설정과 캡처를 시작하고 관리하는 반면, AVCaptureVideoPreviewLayer는 이러한 캡처 세션으로부터 받은 비디오를 화면에 실시간으로 보여주는 역할
    // 이 두 가지를 함께 사용하면 카메라로부터 영상을 캡처하고 동시에 그 영상을 실시간으로 화면에 보여줄 수 있다.
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    
    // 카메라 앵글 테두리 레이어를 설정하는 것
    private var cornerLength: CGFloat = 20 // 모서리 (CGFloat은 CG프레임워크 데이터타입으로 소수점값 표현을 위해 사용 - 그래픽 관련(화면의 크기, 위치, 길이 등 표현) 작업을 수행할때 사용)
    private var cornerLineWidth: CGFloat = 6 // 선의 굵기
    private var rectOfInterest: CGRect { // 계산 속성(리턴 생략)(CGRect는 사각형)
        // CGRect는 사각형의 위치와 크기를 정의하는데 x, y는 시작점 width, heigh으로 너비, 높이를 지정
        // bonds는 뷰(화면) 'bounds.width / 2'는 뷰(화면)의 가로 길이의 중간 지점을 의미
        // 그리고 200 / 2는 사각형의 크기로 설정한 200에서의 반을 의미하므로 '(bounds.width / 2) - (200 / 2)'는 화면 가로 중앙에서 너비(200)의 절반만큼 왼쪽으로 이동한 위치를 나타냄(고로 x와 y의 위치를 이렇게 설정함으로써 화면의 중앙에 위치한 200 x 200 크기의 정사각형 영역을 정의하게 됨
        CGRect(x: (bounds.width / 2) - (200 / 2), y: (bounds.height / 2) - (200 / 2), width: 200, height: 200)
    }
    
    // 계산 속성
    // captureSession이 nil이 아니면 captureSession.isRunning으로 현재 captureSession이 실행중인지 확인한다.(nil이면 flase를 반환해서 세션의 실행 여부를 알 수 없음을 나타냄)
    // captureSession이라는 AVCaptureSession 객체가 실행중인지 여부를 나타냄
    var isRunning: Bool {
        guard let captureSession = self.captureSession else { return false }
        return captureSession.isRunning // AVCaptureSession 클래스 내부에 isRunning이라는 속성이 존재하며 Bool 값을 반환하여 해당 세션이 현재 실행중인지 여부를 알려줌
    }
    
    // 촬영 시 어떤 데이터를 검사할지?(QR Code)
    // AVMetadataObject.ObjectType는 'AVCaputureMetadataOutput에서 처리하고자 하는 메타데이터 오브젝트의 유형을 정의하는 열거형 -> 이 중에서도 .qr은 QR코드를 나타내고 [AVMetadataObject.ObjectType]이 배열에 .qr코드를 추가하는 것
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    // 생성자 직접 재정의?
    // 뷰를 커스터마이징해서 초기화시키기 위함?
    // UIView를 상속받은 클래스에서 해당 뷰를 프로그래밍 방식으로 생성할 때 호출되는 초기화 메서드
    // 개발자가 코드로 직접 UIView의 인스턴스를 만들때 이 생성자가 호출되어 초기화 작업을 수행할 수 있다?
    // 새로운 뷰를 생성하고 초기 속성을 설정하거나, 레이아웃을 구성한다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    
    // AVCaptureSession을 실행하는 화면을 구성
    private func setupView() {
        self.clipsToBounds = true // UIView 클래스 속성(해당 뷰의 하위 뷰들이 자신의 경계를 벗어나는 부분을 잘라내는지 여부)
        self.captureSession = AVCaptureSession() // AVCaptureSession() 인스턴스 생성
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return } // 기본 비디오 관련된 입력 장치를 가져옴(기기가 카메라 지원이 되지 않는다면 nil)
        
        let videoInput: AVCaptureInput // AVCaptureInput은 AVCaptureSession에 입력을 제공하는 추상 클래스(하위 클래스들은 다양한 유형의 데이터 입력을 나타냄 - 비디오, 오디오, 메타데이터 등 처리)(AVCaptureSession에 AVCaptureDevice를 연결하기 위한 클래스)
        
        do {
            // AVCaptureDeviceInput은 AVCaptureDevice를 입력으로 받아들이는 클래스
            // AVCaptureSession에 연결할 수 있는 입력 소스를 나타냄(에러가 발생할 수 있으므로 try 사용)
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error { // catch에 let error를 사용한 이유는 에러 발생시 에러를 잡아서 처리하기 위함
            print(error.localizedDescription)
            return
        }
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        // canAddInput은 captureSession에 카메라 입력(videoInput)을 추가할 수 있는지 확인(Bool 리턴)
        // addInput은 captureSession에 해당 입력을 추가함
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        // AVCaptureMetadataOutput클래스는 AVCaptureSession에 추가하여 메타데이터 출력을 관리
        // 카메라로부터 입력된 미디어의 메타데이터를 캡처하고 처리하는데 사용(일반적으로 바코드, QR 코드)
        // AVCaptureMetadataOutputObjectsDelegate 프로토콜을 준수하는 객체에게 메타데이터 객체를 전달할 수 있다.
        // .metadataObjcetTypes 속성을 통해 어떤 종류의 메타데이터를 캡처할지 설정가능(.qr .code128 등)
        let metadataOutput = AVCaptureMetadataOutput()
        
        // canAddOutput은 captureSession에 metadataOutput을 추가할 수 있는지 확인(Bool 리턴)
        // addOutput은 captureSession에 metadataOutput을 추가
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            // setMetadataObjectsDelegate(self, queue: DispatchQueue.main)은 metadataOutput에 메타데이터 객체를 처리할 delegate를 설정(ReaderView가 델리게이트 역할)하고 메타데이터 처리를 위한 queue도 설정
            // metadataObjectTypes는 어떤 종류의 메타데이터를 캡처할지를 설정(여기선 .qr)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes // .qr이 담겨있음
        } else {
            self.fail()
            return
        }
        
        self.setPreviewLayer() // 포커스 레이어
        self.setFocusZoneCornerLayer() // 포커스 테두리 레이어
        
        // QR코드 인식 범위 설정
        // metadataOutput.rectOfInterest는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정
        // 해당 값은 먼저 AVCaptureSession을 running 상태로 만든 후 지정해줘야 정상 작동한다고 함.
        self.start()
        // rectOfInterest는 QR코드 메타데이터를 찾기 위한 관심 영역을 정의하는 사각형의 영역을 나타냄(영역 설정을 하면 카메라가 해당 영역만을 촬영하고 그 안에서만 QR코드를 감지) -> 결국 그 영역은 CGRect(rectOfInterest 계산 속성)로 사각형의 영역이 정의됨
        // metadataOutputRectConverted는 레이어 좌표 공간에서 메타데이터 출력의 사각형 좌표를 비디오 미리보기 레이어의 좌표 공간으로 변환해주는 역할(바코드를 찾을 관심 영역(rectOfInterest)을 레이어의 좌표 시스템으로 변환 후 metadataOutput.rectOfInterest에 값을 할당하여 메타데이터를 찾을 영역을 설정함)
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
        // previewLayer는 위에 선언된 AVCaptureVideoPreviewLayer? 클래스 타입 변수
        // rectOfInterest는 위에서 만든 화면에 사각형을 만드는 계산 속성
    }
    
    // 중앙에 사각형 포커스 레이어 설정
    private func setPreviewLayer() {
        
        let readingRect = rectOfInterest // 계산 속성
        
        guard let captureSession = self.captureSession else { return }
        
        // AVCaptureVideoPreviewLayer 구성(설명은 위에 속성 부분에)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) // caputerSession의 비디오 입력을 표시하기 위한 미리보기 뷰로 사용(카메라에 입력된 비디오를 화면에 표시하기 위한 레이어 사용)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // 비디오 비율 조정(resizeAspectFill은 레이어의 사각형에 맞게 비디오를 확대 또는 축소해서 레이어를 가득채움)
        previewLayer.frame = self.layer.bounds // previewLayer의 프레임을 ReaderView의 크기와 같도록 설정(bounds는 뷰의 내부 좌표 공간에서의 크기로서 해당 뷰 내에서의 상대적인 위치와 크기를 정의 원점에서 해당 뷰의 크기를 정의)
        
        // 스캔 포커스
        // 스캔할 사각형(포커스존)을 구성, 해당 자리만 흐리지 않도록
        // CAShapeLayer에서 도형 모양을 그리고자 할때 CGPath를 사용(즉 previewLayer에다가 ShapeLayer를 그리는데 ShapeLayer의 모양이 [1.bounds 크기의 사각형, 2.readingRect 크기의 사각형] 두 개가 그려져 있는 것이다??)
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)
        
        // Path(경로, 모양)은 그려졌고 Layer의 특징을 정하고 추가할 것.
        // 먼저 CAShapeLayer의 Path를 위에서 지정한 path로 설정
        // QRReader에서 백그라운드 컬러가 dimeed(흐리게) 처리가 되어야 하므로 Layer의 투명도를 0.6 정도 설정
        // 단 여기서 QRCode를 읽을 부분은 dimeed 처리가 되어 있으면 안됨, 이럴때 fillRule에서 evenOdd를
        // 지정해주는데 Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않음.
        let maskLayer = CAShapeLayer() // CAShapeLayer는 CoreAnimation에서 제공하는 클래스로 경로(Shape)를 기반으로 하는 2D 도형을 그리고 애니메이션 및 스타일링을 적용함.(경로(Paths)기반 그리기: CGPath 객체를 사용하여 직선, 곡선, 다각형등의 도형을 그림)
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd
        
        previewLayer.addSublayer(maskLayer)
        
        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
    }
    
    // 포커스 모서리의 테두리 레이어를 만듦
    private func setFocusZoneCornerLayer() {
        var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius // CALayer는 CoreAnimation 기본 구성 요소중 하나(그래픽 컨텐츠 표현하고 애니메이션 처리하는 객체 - UIView와 매우 유사한 기능)
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > rectOfInterest.width / 2 { cornerLength = rectOfInterest.width / 2 }
        
        // Focus Zone의 각 모서리 point
        // CGPoint는 2차원 좌표 평면에서 한 지점을 표현(x,y 값으로 이루어진 구조체로 주로 좌표를 표현하고 다루는데 사용)(간단하게 말해서 2차원 좌표계에서 한 점의 위치를 나타냄))
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.minY - cornerLineWidth / 2)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX + cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX - cornerLineWidth / 2, y: rectOfInterest.maxY + cornerLineWidth / 2)
        
        // 각 모서리를 중심으로 한 Edge를 그림.
        let upperLeftCorner = UIBezierPath() // UIBezierPath는 경로를 생성하고 관리하는 클래스(직선, 곡선, 사각형, 원 등 다양한 모양의 경로를 만들고 그림)
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
                                radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 0, clockwise: true)
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        
        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
                                radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        // 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가.
        let combinedPath = CGMutablePath() // CGMutablePath는 경로를 만들고 그리는데 사용되는 클래스로 경로(Path)를 만들기 위해 사용되며 선, 곡선, 다각형등을 그리고 편집할 수 있는 가변(mutable)한 경로를 생성
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .square
        
        self.previewLayer!.addSublayer(shapeLayer)
    }
}

// 리더뷰 확장
extension ReaderView {
    
    func start() {
        // 💡 백그라운드 스레드에서 처리하라고 (보라색-권장)메세지가 나오는데 해당 부분을 백그라운드 스레드에서 처리하면 메타데이터를 가져오는데 문제가 발생하고 메타데이터를 메인스레드에서도 처리해도 원활히 되지 않음.
        // 해당 문제는 해결 방법을 찾지 못해서 일단 사용하는데, 권장사항인 만큼 그냥 일단 사용.
        print("AVCaptureSession Start Running")
        self.captureSession?.startRunning() // 캡처세션 시작
        
    }
    
    // QR 읽고나서 사용되는 메서드들?
    // 델리게이트에게 중지, 성공, 실패 상태를 알려줌
    func stop() {
        self.captureSession?.stopRunning() // 캡처세션 중지
        self.delegate?.rederComplete(status: .stop) // 델리게이트 메서드에 스탑(열거형)-Bool 전달)
    }
    
    func fail() {
        self.delegate?.rederComplete(status: .fail)
        self.captureSession = nil
        
    }
    
    func found(code: String) { // QR 코드를 성공적으로 읽었을 때 호출.
        self.delegate?.rederComplete(status: .sucess(code))
    }
}


// 리더뷰 확장해서 AVCaptureMetadataOutputObjectsDelegate 델리게이트 채택
// 카메라가 메타데이터를 출력할 때 발생하는 이벤트를 처리?
extension ReaderView: AVCaptureMetadataOutputObjectsDelegate {
    // 이 metadataOutput 메서드는 카메라에서 받은 메타데이터 오브젝트들을 처리하고 해당 오브젝트중에서 AVCaptureMetadataOutputObject로 변환 가능한 객체가 있다면 그 중에서 첫 번째 값을
    // 사용하여 QR 코드를 찾는 동작을 수행
    // 파라미터 output은 AVCaptureMetadataOutput 객체, metadataObjects은 카메라가 감지한 metadata 객체들의 배열, connection은 AVCaptureConnection 객체로, 연결된 입력 및 출력 장치 사이의 데이터 흐름을 관리
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("GET metadataOutput")
        //stop(isButtonTap: false)
        
        // metadataObjects 배열에서 첫 번째 객체를 가져와서 이 객체가 AVMetadataMachineReadableCodeObject로 타입캐스팅이 가능하고 그 안에 stringValue가 있는지 확인
        // 해당 코드값을 찾았다면 해당 코드값을 출력하고 found 메서드에 호출하여 찾은 코드를 처리하는 것 -> 그리고 stop 메서드로 카메라를 중지
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // 진동을 울림
            //AudioServicesPlayAlertSound(SystemSoundID(1407)) // 이건 사운드인가?
            found(code: stringValue) // QR코드를 성공적으로 읽었을때 호출되는 found
            print("Found metadata Value: \n \(stringValue)")
            stop() // 위 동작들 완료되면 캡처세션 중지
        }
    }
}

// CGPoint 확장
// internal은 접근 제어 키워드로 '같은 모듈 내'에서만 접근할 수 있도록 설정(internal은 default인데 이렇게 명시하는 이유는? -> 굳이 필요없을 것 같은데)
internal extension CGPoint {
    
    // CGPoint + offsetBy
    // 현재 좌표에 dx와 dy를 더해 새로운 CGPoint를 반환함(변경된 좌표를 가진 새로운 CGPoint를 반환함)
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
