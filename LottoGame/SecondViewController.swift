//
//  SecondViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968886435, green: 0.9258887172, blue: 0.8419043422, alpha: 1)
        
        setupNaviBar()
    }
    
    
    // 네비게이션바 설정 메서드
    func setupNaviBar() {
        title = "번호 생성"
        
        let appearance = UINavigationBarAppearance() // 네비게이션바 겉모습을 담당
        appearance.configureWithOpaqueBackground() // 불투명으로
        appearance.backgroundColor = .white
        // 네비게이션 모양 설정
        navigationController?.navigationBar.tintColor = .systemBlue // 네비바 틴트 색상
        navigationController?.navigationBar.standardAppearance = appearance // standard 모양 설정?
        navigationController?.navigationBar.compactAppearance = appearance // compact 모양 설정(가로 방향 화면 사용시 모양 정의?)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance // 스크롤이 맨위로 도달했을 때 네비게이션 바의 모양 정의
        
    }
    
}
