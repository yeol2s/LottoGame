//
//  SecondViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

// 세컨 뷰컨(내 번호)
final class MyNumbersViewController: UIViewController {
    
    // 번호저장 매니저 인스턴스 생성
    var saveManager: NumberSaveManager = NumberSaveManager()
    
    
    // 내 번호 테이블뷰 생성
    // ⭐️ 그냥 백그라운드컬러 하나 하려고 이렇게 클로저 실행문으로 해도 괜찮은가?
    // ⭐️ 레이블 10개만 표시하면되는데 테이블뷰보다 나은 대안이 있나? 그냥 이대로 써도 무방할까?
    private let numChoiceTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false // 테이블뷰 스크롤 비활성화
        tableView.backgroundColor = .clear // 테이블뷰 백그라운드 투명
        return tableView
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.9038607478, green: 0.5367665887, blue: 0.3679499626, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetSavedData), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968886435, green: 0.9258887172, blue: 0.8419043422, alpha: 1)
        print("세컨뷰가 생성되었습니다.")
        setupNaviBar() // 네비 설정
        setupTableView() // 테이블뷰 설정
        setupTableViewConstraints() // 테이블뷰 오토레이아웃
        setButtonConstraints() // 버튼 오토레이아웃
        //saveManager.setSavedData() // ⭐️번호저장 매니저 통해 저장된 번호 확인(여기에 두면 문제가 리로드시 저장된 번호가 로드가 안됨, 근데 willAppear에 넣으면 중복 로드됨)(속성감시자로 전달해야하나?)
    }
    
    // 화면이 다시 나타날때마다 계속 호출(뷰컨트롤러 생명주기)
    // 뷰가 나타나기 전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //saveManager.setSavedData()
        numChoiceTableView.reloadData() // 테이블뷰 리로드
        print("저장 번호 화면이 다시 나타났습니다.")
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
            numChoiceTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
    
    // 리셋버튼 오토레이아웃
    private func setButtonConstraints() {
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: numChoiceTableView.bottomAnchor, constant: 10),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // 저장된 번호 리셋
    @objc func resetSavedData() {
        saveManager.resetSavedData() // 매니저 통해 리셋
        numChoiceTableView.reloadData() // 테이블뷰 리로드
    }
}


extension MyNumbersViewController: UITableViewDelegate {


}

extension MyNumbersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveManager.numbersSave.count // 저장된 번호에 따라 카운트해서 셀 표시 개수

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 일단 만들어놓은 테이블뷰셀 리턴
        let cell = numChoiceTableView.dequeueReusableCell(withIdentifier: "NumChoiceCell", for: indexPath) as! NumChoiceListTableViewCell
        cell.numberLabel.text = saveManager.getNumbersStringArray(row: indexPath.row)
        cell.backgroundColor = .clear // 테이블뷰 셀 투명
        cell.selectionStyle = .none
        return cell
    }
}
    
