//
//  ViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ⭐️ 왜 네비게이션바랑 탭바 만드니까 뷰컨들이 기본 배경이 검은색이 됐지?(그래서 흰색으로 바꿔줌)
        view.backgroundColor = .white
    
        setupNaviBar() // 네비게이션바 메서드 호출
    }
    
    // 네비게이션바 설정 메서드
    func setupNaviBar() {
        title = "Lotto Pick"
        
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
