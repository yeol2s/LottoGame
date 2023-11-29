//
//  QRcodeReaderViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/29/23.
//

import UIKit


// QR 코드리더 뷰컨트롤러
// ⭐️ 컨테이너뷰컨에서 직접 리더뷰 인스턴스 생성해서 접근하는 것보다 이게 올바른거 맞지?
class QRcodeReaderViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReaderView()
        self.tabBarController?.tabBar.isHidden = true // 탭바 숨기기
    }
    
    // 뷰가 사라지기 전
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false // 탭바 보여주기
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
    }
    
}

// 리더뷰 델리게이트 확장
extension QRcodeReaderViewController: ReaderViewDelegate {
    func rederComplete(status: ReaderStatus) {
        switch status {
        case let .sucess(code):
            print("성공\(code ?? "")")
        case .fail:
            print("실패")
        case let .stop(isButtonTap):
            print("중지\(isButtonTap)")
        }
    }
}
