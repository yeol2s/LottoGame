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
    
    // 네비게이션컨트롤러 + 버튼 추가(번호 직접입력)
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(inputNumber))
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
    }
    
    // 화면이 다시 나타날때마다 계속 호출(뷰컨트롤러 생명주기)
    // 뷰가 나타나기 전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveManager.setSaveData() // UserDefaults 데이터 갱신(set)
        numChoiceTableView.reloadData() // 테이블뷰 리로드(⭐️이렇게 리로드 계속 되는것이 비효율적인가?)
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
        
        // + 번호 추가 기능
        self.navigationItem.rightBarButtonItem = self.plusButton
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
        
        let alert = UIAlertController(title: "번호 초기화", message: "현재 저장된 번호가 초기화됩니다. 계속하시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            self.saveManager.resetSavedData() // 매니저 통해 리셋
            self.numChoiceTableView.reloadData() // 테이블뷰 리로드
            print("저장번호가 초기화 되었습니다.")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("저장번호 초기화 취소")
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    // 네비게이션 (+)버튼 번호 추가 기능(직접입력 구현)
    @objc func inputNumber() {
        
    }
}


extension MyNumbersViewController: UITableViewDelegate {


}

extension MyNumbersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveManager.defaultsTemp.count // 저장매니저 임시 저장 배열개수로 셀 표시

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 일단 만들어놓은 테이블뷰셀 리턴
        // dequeueReusableCell 테이블뷰 셀을을 재사용하기 위해 사용되는 메서드
        let cell = numChoiceTableView.dequeueReusableCell(withIdentifier: "NumChoiceCell", for: indexPath) as! NumChoiceListTableViewCell
        
        //⚠️(old) 번호를 정수 -> 문자열로 변경했을때 사용
        //cell.numberLabel.text = saveManager.getSaveData(row: indexPath.row)
        // 매니저한테 유저디폴츠 데이터를 뽑아와서 셀의 공 모양으로 변환하는 메서드에 전달해서 셀에서 addSubView함
        cell.numbersBallListInsert(numbers: saveManager.defaultsTemp[indexPath.row])
        
        // 셀과 연결된 클로저 호출(어떤 번호를 선택해제 할껀지)
        // ⭐️와일드카드를 쓰고 sender를 뺐는데 이렇게 하는게 맞을까?(굳이 콜백함수가 필요없는 경우?)
        cell.saveUnCheckButton = { [weak self] _ in
            guard let self = self else { return }
            print("선택된 인덱스:\(indexPath.row)")
            // 여기서 인덱스를 보내서 삭제하자(저장 매니저에게)
            saveManager.setRemoveData(row: indexPath.row)
            numChoiceTableView.reloadData() // 하트 해제할때마다 즉시즉시 리로드해서 번호를 화면에서 제거
        }
        
        
        cell.backgroundColor = .clear // 테이블뷰 셀 투명
        cell.selectionStyle = .none
        return cell
    }
}
    
