//
//  CustomViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/10/23.
//

import UIKit

// 🔶사이드바 메뉴를 위한 컨테이너 뷰컨트롤러
final class ContainerViewController: UIViewController {
    
    // 메뉴를 보여주기 위해 열거형 선언(열려있는지 닫혀있는지)
    enum MenuState {
        case opend
        case closed
    }
    
    private var menuState: MenuState = .closed // 메뉴 열거형 인스턴스 생성(앱이 처음 실행될때는 닫혀있는 상태)
    
    let menuVC = MenuViewController() // 메뉴 뷰컨트롤러
    let mainVC = NumbersGenerateViewController() // 메인 뷰컨트롤러(번호 생성)
    var navVC: UINavigationController? // 네비게이션컨트롤러 인스턴스 생성 🔶 메인뷰컨은 컨테이너뷰컨에서 네비게이션컨트롤러로 root 시킴(이래야 사이드메뉴시 프레임이 같이 밀리는 듯 - 탭바 제외)
    
    lazy var apiVC = LottoAPIViewController()
    lazy var qrVC = QRcodeReaderViewController()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray
        addChildVCs()
    }
    
    
    // 메인뷰와 메뉴뷰를 하위 뷰 컨트롤러로 추가하는 함수
    private func addChildVCs() {
        // MenuViewController
        menuVC.delegate = self // 메뉴뷰컨 대리자 지정
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        
        // MainViewController
        // 메인 뷰컨을 깔아놓고 🔶 여기서 네비게이션컨트롤러 root(관련 설정은 main뷰컨에서
        mainVC.delegate = self // 메인뷰컨 대리자 지정
        let navVC = UINavigationController(rootViewController: mainVC)
        addChild(navVC) // 자식뷰컨으로 navVC를 추가(첫번째 단계로 계층구조에 포함시키는 것-화면나타나진않음)
        view.addSubview(navVC.view) // 자식뷰로 navVC 뷰를 추가(두번째 단계로 - 화면에 나타남)
        navVC.didMove(toParent: self) // 자식뷰컨이 부모뷰컨에 성공적으로 추가될때 호출(세번째 단계 - 생명주기, 초기화-해제, 동적인 화면 전환 및 재사용 가능해짐)(부모-자식 상호작용 및 화면전환 가능)
        self.navVC = navVC
        
    }
}

// 메인뷰컨트롤러 델리게이트 확장(mainVC.delegate)
extension ContainerViewController: NumbersGenViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    // 컴플리션 핸들러(선택사항으로 만들기 위해 옵셔널 선언)(🔶옵셔널이므로 자동 @escaping?)
    // 🔶지금 이 컴플리션핸들러랑 animate의 컴플리션은 다르잖아? 애니메이트는 애니메이션의 결과를 가지고 하는거고
    // 🔶이 컴플리션핸들러가 의미가 있어? (나중을 위한 컴플리션핸들러를 쓴 것인가??)
    // 애니메이션 처리(스프링 애니메이션: 스프링의 동작을 모방하여 애니메이션 효과를 만들어내는 기술)(빠르게 싲가하여 완만하게 멈추는 애니메이션 효과)
    // withDuration : 애니메이션의 지속 시간을 초단위로 나타내며 애니메이션의 시작부터 끝까지 얼마동안 진행될지를 결정
    // delay: 애니메이션의 시작을 지연시킬 시간을 초 단위로 나타냄(1초 설정하면 애니메이션이 1초 후 시작)
    // usingSpringWithDamping: 스프링 애니메이션을 적용할때 사용하는 매개변수(스프링의 감쇠 정도를 나타냄 값이 작을 수록 스프링 애니메이션이 더 많은 효과, 값이 클수록 스프링 효과가 덜 나타남)
    // initialSpringVelocity: 스프링 애니메이션의 초기 속도를 나타냄(0이면 초기 속도가 없고, 양수나 음수값을 설정하면 애니메이션의 방향을 제어함)
    // animatios: 애니메이션 중 수행할 뷰 속성 변경 블록을 나타내는 클로저(이 블록내에서 애니메이션을 원하는대로 정의할 수 있고 뷰의 프로퍼티를 변경하여 애니메이션을 만듦)
    // options: 애니메이션 옵션(.curveEaseInOut은 애니메이션의 시간에 따른 진행을 나타내는 타이밍 함수로 시작할 때와 끝날 때 모두 느리게 시작하고 느리게 끝나도록 애니메이션 타이밍을 조절 -> 서서히 가속 후 서서히 감속)
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed: // 현재 닫혀있다면
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.mainVC.view.frame.size.width - 110 // mainVC의 뷰의 너비에서 100만큼을 뺀값을 navVC origin.x에 넣어줌으로 navVC의 x좌표가 변하면서 결과적으로 오른쪽이동
            } completion: { [weak self] done in // animate 완료 핸들러(Bool)(이 클로저가 힙에 저장되고 컨테이너뷰컨인스턴스를 가리키기때문에 weak) // 🔶 얘가 위 컴플리션핸들러로 전달되는게 아니잖아?
                if done {
                    self?.menuState = .opend // 열었으니까 상태를 오픈으로 변경
                }
            }
        case .opend: // 현재 열려있다면
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0 // navVC의 origin.x 를 0으로 다시 해줌으로써 원점으로 복귀
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed // 닫았으니까 상태를 클로즈로 변경
                    DispatchQueue.main.async { // 메인큐로 다시보냄(🔶UIView.animate는 비동기적으로 처리가 되고, UI관련된 작업은 메인으로 다시보내야됨(메인스레드만 화면을 다시그리는일을 하기떄문))
                        completion?() // 옵셔널체이닝에서 ?() - ()? 의 차이는 (앞 물음표는 함수가 있을수도 없을수도있다. - 뒤 물음표는 함수의 결과값이 있을수도 없을수도 있다. 의 차이이다.)(고로 이거는 클로저가 있을수도 없을수도)
                    }
                }
            }
        }
    }
}


// 메뉴뷰컨트롤러 델리게이트 확장(menuVC.delegate)
extension ContainerViewController: MenuViewControllerDelegate {
    //프로토콜 메서드(셀 선택시 해당 열을 가지고 메뉴를 열기)
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil) // 🔶우선 메뉴 상태를 .opend or .closed 바꾸기 위해 토글
        
        // 들어온 menuItem을 가지고 스위칭(MenuOptions.케이스를 가지고 들어올 것)
        switch menuItem {
        case .home:
            // 여긴 일단 구현 보류(사용 여부가 없음)
            break
        case .info:
            navVC?.pushViewController(apiVC, animated: true) // 네비컨트롤러 push로 화면이동
            break
        case .qrCode:
            qrVC.modalPresentationStyle = .fullScreen
            present(qrVC, animated: true)
            break
        case .map:
            break
        }
    }
    
    //    func resetToHome() {
    //
    //    }
    
}
