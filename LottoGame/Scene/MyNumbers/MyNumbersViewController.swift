//
//  SecondViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

// 세컨 뷰컨(내 번호)
final class MyNumbersViewController: UIViewController {
    
    // 내 번호 테이블뷰 생성
    // ⭐️ 그냥 백그라운드컬러 하나 하려고 이렇게 클로저 실행문으로 해도 괜찮은가?
    // ⭐️ 셀은 그냥 NumTableViewCell을 쓰는게 바람직한가?
    private let numChoiceTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear // 테이블뷰 백그라운드 투명
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968886435, green: 0.9258887172, blue: 0.8419043422, alpha: 1)
        
        setupNaviBar() // 네비 설정
        setupTableView() // 테이블뷰 설정
        setupTableViewConstraints() // 테이블뷰 오토레이아웃
        print("세컨뷰가 생성되었습니다.")
    }
    
    // 화면이 다시 나타날때마다 계속 호출(뷰컨트롤러 생명주기)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("화면이 다시 나타났습니다.")
    }
    
    
    // 네비게이션바 설정 메서드
    private func setupNaviBar() {
        title = "내 번호"
        
        let appearance = UINavigationBarAppearance() // 네비게이션바 겉모습을 담당
        appearance.configureWithOpaqueBackground() // 불투명으로
        appearance.backgroundColor = .white
        // 네비게이션 모양 설정
        navigationController?.navigationBar.tintColor = .systemBlue // 네비바 틴트 색상
        navigationController?.navigationBar.standardAppearance = appearance // standard 모양 설정?
        navigationController?.navigationBar.compactAppearance = appearance // compact 모양 설정(가로 방향 화면 사용시 모양 정의?)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance // 스크롤이 맨위로 도달했을 때 네비게이션 바의 모양 정의
    }
    
    // 내 번호 테이블뷰 대리자 지정 및 관련 설정
    private func setupTableView() {
        numChoiceTableView.delegate = self
        numChoiceTableView.dataSource = self
        numChoiceTableView.rowHeight = 60
        numChoiceTableView.register(NumChoiceListTableViewCell.self, forCellReuseIdentifier: "NumChoiceCell")
    }
    
    // 테이블뷰 오토레이아웃
    private func setupTableViewConstraints() {
        view.addSubview(numChoiceTableView)
        numChoiceTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numChoiceTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            numChoiceTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            numChoiceTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            numChoiceTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
}

extension MyNumbersViewController: UITableViewDelegate {


}

extension MyNumbersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // 일단 10개만 표시

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 일단 만들어놓은 테이블뷰셀 리턴
        let cell = numChoiceTableView.dequeueReusableCell(withIdentifier: "NumChoiceCell", for: indexPath) as! NumChoiceListTableViewCell
        cell.numberLabel.text = "테스트"
        cell.backgroundColor = .clear // 테이블뷰 셀 투명
        cell.selectionStyle = .none
        return cell
    }
}
    
