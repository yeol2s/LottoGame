//
//  QRcodeReaderViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/29/23.
//

import UIKit


// QR 코드리더 뷰컨트롤러
// ⭐️ 컨테이너뷰컨에서 직접 리더뷰 인스턴스 생성해서 접근하는 것보다 이게 올바른거 맞지?
final class QRcodeReaderViewController: UIViewController {
    
    // !(느낌표)로 암시적 언래핑 옵셔널 사용(값이 있을수도, 없을수도)(값이 있다고 가정하고 사용, 강제로 옵셔널 해제를 수행할 필요 없고 컴파일러가 해당 변수에 접근할 때 자동으로 옵셔널 해제함)(값이 없을때 강제로 접근하면 런타임 오류가 발생할 수 있음)
    var readerView: ReaderView! // 암시적 언래핑
    
    lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(qrCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    override func loadView() {
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 뷰가 스크린에 나타나기 전(뷰가 화면에 나타날때마다 계속 호출)
    // 다른 화면에 갔다올때마다 리더뷰를 다시 시작하기 위해(큐알 재실행)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear 호출")
        self.tabBarController?.tabBar.isHidden = true // 탭바 숨기기
        
        // ⭐️이 부분에서 리더뷰를 못불러오는 경우가 발생할 수 있을까?
        // 발생한다면 대비를 어떻게 처리해야하는지
        setupReaderView() // 리더뷰 셋업 및 시작
        
    }
    
    // 뷰가 사라지기 전
    // addSubView 메서드로 하위뷰를 추가할때는 상위뷰컨트롤러의 뷰컨트롤러 생명주기 메서드가 호출되지 않는다.(해당 뷰컨트롤러의 상태가 변경되는 것이 아니기 때문에)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false // 탭바 보여주기
        
        if readerView.isRunning { // 뷰가 사라질때 캡처세션이 실행중이라면
            print("viewWillDisappear:캡처세션 종료")
            readerView.stop() // 캡처세션 종료
        }
        
    }
    
    private func setupReaderView() {
        readerView = ReaderView(frame: view.bounds) // 리더뷰 객체 생성(view.bounds->현재 뷰의 크기에 해당하는 CGRect 영역)
        readerView.delegate = self
        view.addSubview(readerView)
        buttonConstraints()
        readerView.start()
    }
    
    // QR 코드 종료 버튼 오토레이아웃
    private func buttonConstraints() {
        view.addSubview(stopButton) // 뷰위에 종료버튼을 올린다.
        
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 100),
            stopButton.heightAnchor.constraint(equalToConstant: 40),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // QR코드 종료버튼 눌렀을때
    // ⭐️ 이렇게 뷰, 버튼 삭제하고, 탭바컨트롤러 다시 보이게 하는 이런 로직 괜찮은가?
    @objc private func qrCancelButtonTapped() {
        //self.view.removeFromSuperview()
        //self.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true)
    }
    
    deinit {
        print("QRReader 메모리 해제")
    }
    
}

// 리더뷰 델리게이트 확장
extension QRcodeReaderViewController: ReaderViewDelegate {
    
    func rederComplete(status: ReaderStatus) {
        switch status {
        case let .sucess(code):
            if let code = code {
                showAlert(message: "인식 완료", code)
            } else {
                fallthrough // code 못불러올시 다음블럭 실행시킴
            }
        case .fail:
            showAlert(message: "인식 실패")
        case .stop:
            showAlert(message: "인식 중지")
        }
    }
    
    private func showAlert(message: String...) {
        
        let alert = UIAlertController(title: "알림", message: message[0], preferredStyle: .alert)
        
        switch message[0] {
        case "인식 완료":
            print("\(message[0]): \(message[1])")
            alert.title = "사이트에 연결합니다."
            alert.message = message[1]
            let success = UIAlertAction(title: "연결", style: .default) { [weak self] action in
                if let url = URL(string: message[1]) {
                    UIApplication.shared.open(url) // 웹사이트 연결
                } else {
                    print("QR Code URL 연결에 실패했습니다.")
                    self?.captureSessionRetry() // 캡처세션 재시작
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] cancel in
                self?.captureSessionRetry() // 캡처세션 재시작
            }
            alert.addAction(success)
            alert.addAction(cancel)
        case "인식 실패":
            let check = UIAlertAction(title: "확인", style: .default) { [weak self] check in
                self?.captureSessionRetry() // 캡처세션 재시작
            }
            alert.addAction(check)
        case "인식 중지":
            let check = UIAlertAction(title: "확인", style: .default) { [weak self] check in
                self?.captureSessionRetry() // 캡처세션 재시작
            }
            alert.addAction(check)
        default:
            dismiss(animated: true) // 아무것도 안될시 이전 화면으로 돌아가게
            break
        }
        present(alert, animated: true)
    }
    
    // 캡처세션 재시작
    // 캡처가 완료되면 캡처세션이 멈추므로 버튼 동작에 따라 재시작하는 메서드
    // 캡처세션이 실행중일 가능성은 매우적은듯
    private func captureSessionRetry() {
        if readerView.isRunning { // 캡처세션 실행중이라면
            readerView.stop() // 중지
        } else { // 캡처세션 중지상태라면
            readerView.start() // 캡처세션 시작
        }
    }
    
}
