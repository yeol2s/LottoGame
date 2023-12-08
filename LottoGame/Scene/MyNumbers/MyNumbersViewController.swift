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
    
    // ❗️ (테스트) 번호 공으로 만드는 UIStackView(지연저장속성으로)
    lazy var ballListView: NumberBallListView = NumberBallListView()
    
    // 내 번호 테이블뷰 생성
    // ⭐️ 그냥 백그라운드컬러 하나 하려고 이렇게 클로저 실행문으로 해도 괜찮은가?
    // ⭐️ 레이블 10개만 표시하면되는데 테이블뷰보다 나은 대안이 있나? 그냥 이대로 써도 무방할까?
    private let numChoiceTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false // 테이블뷰 스크롤 비활성화
        tableView.backgroundColor = .clear // 테이블뷰 백그라운드 투명
        return tableView
    }()
    
    // 번호 직접 추가 컬렉션뷰 생성
    // 지연저장속성으로 만듦(setup시 생성)
    // frame: view.bounds는 컬렉션뷰의 초기 프레임을 설정, view.bounds는 부모 뷰컨 화면 영역에 해당하는 CGRect를 생성(컬렉션뷰가 전체화면을 차지하도록) ----> 그렇지만 오토레이아웃을 할 것이므로 .zero 로 설정
    // collectionViewLayout는 컬렉션뷰의 레이아웃을 설정(UICollectionViewFlowLayout()는 컬렉션뷰의 아이템을 배치하기 위한 기본적인 레이아웃)
    lazy var addNumbersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let numbers: [Int] = Array(1...45) // 1~45를 배열로 만듦
    lazy var selectedNumbers: [Int] = [] // 선택된 번호를 넣을 배열(지연저장속성)
    
    
    // 저장된 번호 리셋 버튼
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.9038607478, green: 0.5367665887, blue: 0.3679499626, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetSavedDataTapped), for: .touchUpInside)
        return button
    }()
    
    // 네비게이션컨트롤러 + 버튼 추가(번호 직접입력)
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(inputNumber))
        return button
    }()
    
    // 번호 직접 추가 컬렉션뷰 '추가' 버튼
    private lazy var addNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9895486236, blue: 0.7555574179, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNumberViewTapped), for: .touchUpInside)
        return button
    }()
    
    // 번호 직접 추가 컬렉션뷰 '종료' 버튼
    private lazy var addNumberCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9895486236, blue: 0.7555574179, alpha: 1)
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNumberViewCloseTapped), for: .touchUpInside)
        return button
    }()
    
    // 선택된 번호 출력할 레이블
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "여기에 번호가 입력된다."
        label.font = UIFont.systemFont(ofSize: 18)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 번호 선택 스택뷰에 사용될 '추가', '취소' 버튼 스택뷰
    private lazy var addNumberButtonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 1
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 번호 선택 추가 스택뷰
    private lazy var addNumbersStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 3 // 스택뷰 내부의 간격
        view.axis = .vertical
        view.backgroundColor = .white
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 5
        //view.distribution = .fill // 크기 분배 어떻게 할건지?
        //view.alignment = .fill // 정렬(fill은 완전히 채우는 정렬)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var setViews = [addNumbersCollectionView, numberLabel, addNumberButtonStackView]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968886435, green: 0.9258887172, blue: 0.8419043422, alpha: 1)
        print("세컨뷰가 생성되었습니다.")
        setupNaviBar() // 네비 설정
        setupTableView() // 테이블뷰 설정
        setupCollectionView() // 컬렉션뷰 설정
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
    
    // 저장 번호 직접 추가 컬렉션뷰 대리자 지정 및 관련 설정
    private func setupCollectionView() {
        addNumbersCollectionView.delegate = self
        addNumbersCollectionView.dataSource = self
        addNumbersCollectionView.register(AddNumbersCollectionViewCell.self, forCellWithReuseIdentifier: "AddNumbersCell")
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
    
    // 번호 추가 화면 스택뷰 오토레이아웃
    private func setupAddStackViewConstraints() {
        addNumbersCollectionView.backgroundColor = .clear
        setupButtonConstraints()
        
        for views in setViews {
            addNumbersStackView.addArrangedSubview(views)
        }

        view.addSubview(addNumbersStackView) // 하위뷰로 스택뷰 추가
        numberLabel.addSubview(ballListView) // ❗️ (테스트)넘버레이블에 번호 공바꾸기 뷰 추가
        
        addNumbersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ballListView.translatesAutoresizingMaskIntoConstraints = false // 테스트
        NSLayoutConstraint.activate([
            addNumbersStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addNumbersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addNumbersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addNumbersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        // ❗️ (테스트)공바꾸기 뷰 오토레이아웃
        NSLayoutConstraint.activate([
            ballListView.centerXAnchor.constraint(equalTo: self.numberLabel.centerXAnchor),
            ballListView.centerYAnchor.constraint(equalTo: self.numberLabel.centerYAnchor)
        ])
        
    }
    
    // (번호 추가 화면 스택뷰) 추가, 종료 버튼 스택뷰 오토레이아웃
    private func setupButtonConstraints() {
        addNumberButtonStackView.addArrangedSubview(addNumberButton)
        addNumberButtonStackView.addArrangedSubview(addNumberCloseButton)
    }
    
    private func setupBallListViewConstraints() {
        
    }
    

    
    // 저장된 번호 리셋
    @objc func resetSavedDataTapped() {
        
        // 저장된 번호가 있을때만 실행되도록 가드문
        guard !saveManager.defaultsTemp.isEmpty else { return }
        
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
        print("번호 입력 '+' 버튼이 눌렸습니다.")
        setupAddStackViewConstraints()
        resetButton.isEnabled = false // 리셋 버튼 비활성화
    }
    
    // (직접)번호 추가 컬렉션뷰 '닫는' 버튼 셀렉터 메서드
    @objc func addNumberViewCloseTapped() {
        addNumbersStackView.removeFromSuperview() // 부모뷰로부터 뷰 삭제(화면 닫음)
        resetButton.isEnabled = true // 리셋 버튼 활성화
    }
    
    // (직접)번호 추가 컬렉션뷰 '추가' 버튼 셀렉터 메서드
    @objc func addNumberViewTapped() {
        
        resetButton.isEnabled = true // 리셋 버튼 활성화
    }
}

// 테이블뷰 델리게이트 (테이블뷰 일어나는 일 관련(동작))
extension MyNumbersViewController: UITableViewDelegate {


}

// 테이블뷰 데이터소스(테이블뷰 구성)
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

// 컬렉션뷰 델리게이트 (컬렉션뷰 일어나는 일 관련(동작))
extension MyNumbersViewController: UICollectionViewDelegate {
    // 특정 셀 아이템 선택시 호출
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedNumber = numbers[indexPath.item] // 몇번째 아이템이 선택되었는지 뽑아서 넣고
        
        if selectedNumbers.count < 6 { // 현재 저장중인 번호가 6개 미만일때만 실행
            if !selectedNumbers.contains(selectedNumber) {
                selectedNumbers.append(selectedNumber) // 포함되어있지 않은 번호면 저장 배열에 추가
            } else { // 포함되어 있다면 삭제
                if let index = selectedNumbers.firstIndex(of: selectedNumber) {
                    selectedNumbers.remove(at: index) // 포함되어있다면 저장 배열에서 삭제
                }
            }
        } else { // 현재 저장중인 번호가 6개 이상이라면(중복 번호를 누른다면 삭제되도록)
            if let index = selectedNumbers.firstIndex(of: selectedNumber) {
                selectedNumbers.remove(at: index) // 포함되어있다면 저장 배열에서 삭제
            }
        }
        // 임시 테스트용(문자열로 넣음 -> 공 모양으로 변환 예정)
        let numberString = selectedNumbers.map { String($0) }
        numberLabel.text = numberString.joined(separator: "  ")
        
        // ❗️ 테스트 // 🤔 아마 스택뷰로 추가해야되지 않을까?
//        ballListView.displayNumbers(selectedNumbers)
    
    }
}

// 컬렉션뷰 데이터소스(컬렉션뷰 구성)
extension MyNumbersViewController: UICollectionViewDataSource {
    // 컬렉션뷰 몇개의 데이터 표시할건지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count // 1~45번호 배열
    }
    
    // 셀을 어떻게 그려낼건지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNumbersCell", for: indexPath) as! AddNumbersCollectionViewCell
        let number = numbers[indexPath.item] // 아이템 인덱스번호를 뽑아서
        cell.configure(number) // 1~45까지의 번호를 한번씩 셀의 configure 메서드에 보내서 레이블에 표시
        return cell
    }
    
    
}
    
