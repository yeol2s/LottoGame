//
//  ViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit

class ViewController: UIViewController {
    
    // 테이블뷰 생성(번호 5줄 나열)
    // ⭐️ 굳이 번호 표시로 테이블뷰를 할 필요는 없는 것 같은데..(보류)
    private let numTableView = UITableView()
    
    private lazy var generateButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8178957105, blue: 1, alpha: 1)
        button.layer.borderWidth = 1 // 버튼 선의 넓이
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // 버튼 선의 색상
        button.layer.cornerRadius = 5 // 모서리 둥글게
        button.setTitle("번호 생성", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // 폰트 설정
        button.addTarget(self, action: #selector(genButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 번호 생성 인스턴스 생성
    var numberGenManager: NumberGenManager = NumberGenManager()
    
    //private let stackView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ⭐️ 왜 네비게이션바랑 탭바 만드니까 뷰컨들이 기본 배경이 검은색이 됐지?(그래서 흰색으로 바꿔줌)
        view.backgroundColor = .white
    
        setupNaviBar() // 네비게이션바 메서드 호출
        setupTableView() // 테이블뷰 대리자 지정 설정 및 셀등록 함수 호출
        setupTableViewConstraints() // 테이블뷰 오토레이아웃
        setupGenButton() // 버튼 오토레이아웃
        
        print("시작")
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
    
    
    // 테이블뷰 대리자 지정 및 관련 설정
    func setupTableView() {
        numTableView.delegate = self
        numTableView.dataSource = self
        
        numTableView.rowHeight = 50
        
        // 셀 등록(셀 메타타입 등록)
        numTableView.register(NumTableViewCell.self, forCellReuseIdentifier: "NumCell")
    }
    
    // 테이블 뷰 오토레이아웃
    func setupTableViewConstraints() {
        view.addSubview(numTableView)
        numTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            numTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            numTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            numTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor) // 화면에 반만 사용하도록
        ])
    }
    
    // ⭐️나중에 테이블뷰와 같이 스택뷰로 묶자
    // 버튼 오토레이아웃
    func setupGenButton() {
        view.addSubview(generateButton)
        generateButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 버튼의 크기
            generateButton.widthAnchor.constraint(equalToConstant: 200),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
            // 버튼의 위치
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100) // 화면에 반에서 100 띄움
        ])
    }
    
    // 번호 생성버튼 셀렉터
    @objc func genButtonTapped() {
        print("번호가 생성되었습니다.")
        numberGenManager.generateLottoNumbers()
        numTableView.reloadData()
    }
    
}

// 테이블뷰 델리게이트 확장(뷰델리게이트)
extension ViewController: UITableViewDelegate {
    
    
}

// 테이블뷰 델리게이트 확장(Datasource)
extension ViewController: UITableViewDataSource {
    
    // 테이블뷰 몇개의 데이터 표시할건지
    // 테이블뷰 reloadData()가 호출될때마다 호출됨
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberGenManager.getNumbersList().count // 매니저한테 생성된 번호 배열 리스트를 받아서 카운트해서 테이블뷰셀 생성
    }
    
    // ⭐️indexPath가 특정 행의 위치를 지정하는데 사용된다고 하는데 정확한 동작 원리가 어떻게 되는지
    // 그냥 단순 배열 인덱스처럼 사용되는건지? (section은 그룹이고? row는 행이고?)
    // 이게 그냥 단순한 인덱스가 아니고 뭔가 셀과 정보를 깊게 주고받는 그런 느낌? 내가 알 수 없는
    // 이게 reloadData() 될때 어떤 동작원리로.. 얘가 값을 저장했다가 한칸씩 만들어내는 것이 어떻게
    // 1 -> 1, 2 -> 1, 2, 3 이런식으로 불러오나??
    // 셀의 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numTableView.dequeueReusableCell(withIdentifier: "NumCell", for: indexPath) as! NumTableViewCell
        
        let numChangeString = numberGenManager[indexPath.row]
        print("테이블뷰 셀 in :\(numChangeString)")
        
        //cell.numberLabel.text =
        cell.selectionStyle = .none // 셀 선택시 회색으로 안변하게 하는 설정
        
        return cell
    }
    
    
    
}

