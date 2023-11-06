//
//  SceneDelegate.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
// SceneDelegate는 (다중창 환경 도입 후)다른 씬으로 넘어가거나, 그런 시점들을 파악하기 위한 대리자
// 씬(iOS13 이후)의 개념이 도입되면서 앱 델리게이트의 역할에서 몇가지 개념을 씬델리게이트로 분할함(결국 하나의 포커스된 화면 관리라고 보면 되는듯?)
    
    
    var window: UIWindow?

    // (앱의 생명주기) 특정 Scene 객체가 처음 생성되고 연결될 때 호출(Scene 객체가 생성되고 화면에 연결되기 전에
    // 호출되므로 초기화 및 설정 작업을 수행하기 적합한 시점)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 탭바 컨트롤러 생성
        let tabBarVC = UITabBarController()
        
        // 네비게이션 컨트롤러 생성
        // ⭐️ 네비게이션 컨트롤러 두개다 사용할꺼니까 이렇게 두개 만드는게 맞나?
        let naviVC = UINavigationController(rootViewController: NumbersGenerateViewController()) // 뷰컨에다가 생성
        let secondVC = UINavigationController(rootViewController: MyNumbersViewController()) // 세컨뷰도 네비게이션컨트롤러 생성
        
//        // 탭바 타이틀 설정
//        naviVC.title = "메인 화면"
//        secondVC.title = "번호 생성"
        
        tabBarVC.setViewControllers([naviVC, secondVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        naviVC.tabBarItem = UITabBarItem(title: "메인 화면", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        secondVC.tabBarItem = UITabBarItem(title: "내 번호", image: UIImage(systemName: "heart.fill"), selectedImage: nil)
        
        // 기본 루트뷰를 탭바 컨트롤러로 설정
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible() // 터치 이벤트를 받을 수 있게 사용자 입력 활성화?
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

