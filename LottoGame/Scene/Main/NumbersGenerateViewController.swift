//
//  ViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit


// 메인 뷰컨
final class NumbersGenerateViewController: UIViewController {
    
    // 테이블뷰 생성(번호 10줄 나열)
    private let numTableView = UITableView()
    
    // 번호 생성 버튼
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8178957105, blue: 1, alpha: 1)
        button.layer.borderWidth = 3 // 버튼 선의 넓이
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // 버튼 선의 색상
        button.layer.cornerRadius = 5 // 모서리 둥글게
        button.setTitle("번호 생성", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // 폰트 설정
        button.addTarget(self, action: #selector(genButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 리셋 버튼
    // ⭐️나중에 아이콘 넣을 것(기능 구현부터)
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9895486236, blue: 0.7555574179, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0, green: 0.6058896184, blue: 0.3960165381, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 번호 생성 인스턴스 생성
    var numberGenManager: NumberGenManager = NumberGenManager()
    
    //private let stackView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        setupNaviBar() // 네비게이션바 메서드 호출
        setupTableView() // 테이블뷰 대리자 지정 설정 및 셀등록 함수 호출
        setupTableViewConstraints() // 테이블뷰 오토레이아웃
        setupGenButtonConstraints() // 생성 버튼 오토레이아웃
        resetButtonConstraints() // 리셋 버튼 오토레이아웃
        
        print("시작")
    }
    
    // 네비게이션바 설정 메서드
    private func setupNaviBar() {
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
    private func setupTableView() {
        numTableView.delegate = self
        numTableView.dataSource = self
        
        numTableView.rowHeight = 60
        
        // 셀 등록(셀 메타타입 등록)
        numTableView.register(NumTableViewCell.self, forCellReuseIdentifier: "NumCell")
    }
    
    // 테이블 뷰 오토레이아웃
    private func setupTableViewConstraints() {
        view.addSubview(numTableView)
        numTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            numTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            numTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            numTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor) // 화면에 반만 사용하도록
        ])
    }
    
    // ⭐️ 나중에 테이블뷰와 같이 스택뷰로 묶자
    // 생성 버튼 오토레이아웃
    private func setupGenButtonConstraints() {
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
    
    // ⭐️ 아래와 같이 리셋버튼은 테이블뷰와 생성버튼 중간에 있는데 y기준 제약조건을 탑앵커만 테이블뷰 기준으로 잡았고 바텀앵커는 잡지 않았는데 문제 없는지(스토리보드는 이런 경우 막 빨간색으로 제약조건 에러가 떴던거 같아서)
    // 리셋 버튼 오토레이아웃
    private func resetButtonConstraints() {
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: numTableView.bottomAnchor, constant: 80)
        ])
        
    }
    
    // 번호 생성버튼 셀렉터
    @objc private func genButtonTapped() {
        if numberGenManager.generateLottoNumbers() {
            print("번호가 생성되었습니다.")
            numTableView.reloadData()
        }
    }
    
    // ⭐️ 리셋 이렇게 구현하는거 괜찮음?
    // 번호 리셋버튼 셀렉터
    @objc private func resetButtonTapped() {
        
        // Alert 설정(UIAlertController부터 인스턴스 생성)
        let alert = UIAlertController(title: "번호 초기화", message: "번호를 초기화 하시겠습니까?", preferredStyle: .alert)
        
        // 컨트롤러 생성후 UIAlertAction을 구현
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("리셋 확인 버튼이 눌렸습니다.")
            // 클로저 내부에서 외부 속성에 접근하니까 self
            self.numberGenManager.resetNumbers() // 매니저한테 초기화 요청
            self.numTableView.reloadData() // 테이블뷰 리로드
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("리셋 취소 버튼이 눌렸습니다.")
        }
        
        // alert창 위에 Action을 올려준다.
        alert.addAction(success)
        alert.addAction(cancel)
        
        // Alert창 자체도 다음 화면으로 넘어가는 것과 같으므로 present 메서드를 사용해서 띄운다.
        // present는 뷰컨에서만 가능했던 것으로 안다.
        present(alert, animated: true) // completion은 생략
        
    }
}


// 테이블뷰 델리게이트 확장(뷰델리게이트)
extension NumbersGenerateViewController: UITableViewDelegate {
    
    
}

// 테이블뷰 델리게이트 확장(Datasource)
extension NumbersGenerateViewController: UITableViewDataSource {
    
    // 테이블뷰 몇개의 데이터 표시할건지
    // 테이블뷰 reloadData()가 호출될때마다 호출됨
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberGenManager.getNumbersList().count // 매니저한테 생성된 번호 배열 리스트를 받아서 카운트해서 테이블뷰셀 생성
    }
    
    // indexPath가 결국에는 numberOfRowsInSection을 통해 "아 셀을 몇개를 그려야 하는 구나" 하고
    // 내용을 전달을 주고받고(???) indexPath를 통해 셀을 그려내는 것?
    // 스크롤할때 얘는 재구성이 됨
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numTableView.dequeueReusableCell(withIdentifier: "NumCell", for: indexPath) as! NumTableViewCell
        
        //let numStringChanged = numberGenManager[indexPath.row]
        //print("테이블뷰 셀 in :\(numStringChanged)")
        
        // 매니저의 문자열변환 함수를 호출해서 indexPath를 전달해서 numbers 구조체 배열의
        // 정수들을 문자열로 변환해서 리턴받음
        cell.numberLabel.text = numberGenManager.getNumberStringChange(row: indexPath.row)
        cell.selectionStyle = .none // 셀 선택시 회색으로 안변하게 하는 설정
        
        return cell
    }
    
    
    
}

