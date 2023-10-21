//
//  ViewController.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import UIKit


// 메인 뷰컨
final class NumbersGenerateViewController: UIViewController {
    
    // 📌유저디폴츠 객체 생성(여기서 쓸지 안쓸지는 아직)
    let userDefaults = UserDefaults.standard
    let saveKey: String = "MyNumbers"
    
    //⭐️⭐️ 번호 해제 가져오는거 -> 속성감시자?? 노티피케이션?? 클로저?? 커스텀델리게이트패턴??
    
    // 테이블뷰 생성(번호 10줄 나열)
    private let numTableView = UITableView()
    
    // 번호 생성 인스턴스 생성
    var numberGenManager: NumberGenManager = NumberGenManager()
    
    
    // ⭐️ 아래 UI속성들을 lazy var로 선언하는 이유가 지연 저장 속성으로 뷰가 먼저 올라간다음 나오게 하려고 하는건가?(어쨌든 뷰와 연관되어있으니까? -> 셀에서는 속성들에 lazy var를 사용하지 않아도 됐는데)
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
        button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    

    
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
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //numberGenManager.resetNumbers()
        numTableView.reloadData()
    }
    
    // 네비게이션바 설정 메서드
    // ⭐️나중에 스크롤 내릴때 네비게이션바 나오게끔 하자?
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
        
        numTableView.rowHeight = 60 // 테이블뷰 셀 높이
        
        // 셀 등록(셀 메타타입 등록)
        numTableView.register(NumTableViewCell.self, forCellReuseIdentifier: "NumCell")
    }
    
    // 테이블 뷰 오토레이아웃
    private func setupTableViewConstraints() {
        view.addSubview(numTableView) // 테이블뷰를 뷰에 올림
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
    
    // ⭐️ 나중에 번호가 있을때만 리셋버튼이 눌리게 설정하자.
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
    
    // ⭐️ 리셋 이렇게 구현하는거 괜찮음?(매니저로 옮겨야 하나?)
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
    // ⭐️리로드 될때마다 indexPath의 개수에따라 이 메서드가 반복해서 실행하는 듯?
    // row는 행 section은 섹션(그룹같은 개념)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = numTableView.dequeueReusableCell(withIdentifier: "NumCell", for: indexPath) as! NumTableViewCell
        
        //let numStringChanged = numberGenManager[indexPath.row]
        //print("테이블뷰 셀 in :\(numStringChanged)")
        
        // 매니저의 문자열변환 함수를 호출해서 indexPath를 전달해서 numbers 구조체 배열의
        // 정수들을 문자열로 변환해서 리턴받음
        let number = numberGenManager.getNumberStringChange(row: indexPath.row)

        
        cell.numberLabel.text = number
        cell.selectionStyle = .none // 셀 선택시 회색으로 안변하게 하는 설정
        print("셀 재구성:\(indexPath.row)")
        
        // ⭐️ 번호 저장 이렇게 구현하는게 괜찮은 것인가?
        // ✅ 번호 저장 버튼 구현을 정리하자면
        // 셀에서 일단 뷰컨과 연결되는 클로저를 정의하고 셀 자신을 전달하고 뷰컨에서 senderCell로
        // 접근해서 셀에 있는 번호 저장 버튼의 설정을 해주고 있다.(setButtonStatus)
        // 그리고 번호 생성 매니저에 접근해서 인덱스 값을 가지고 numbers의 isSaved를 토글 함으로써
        // 셀을 다시 그리는 경우에 numbers의 isSaved를 인덱스 값으로 접근해서 정확한 자리에 다시
        // 위치하게끔 구현함.
        // ⭐️셀에 연결된 클로저(이게 셀에 있는 클로저 변수에 전달되서 담긴다고 봐야하나?)
        cell.saveButtonPressed = { [weak self] senderCell in
            // ⭐️ self를 약한 참조로 캡쳐(캡처리스트)하고 guard let 바인딩을 통해 self(뷰컨객체)가 존재하는지 확인하고 존재하지 않는다면 클로저를 빠져나감. 고로 self를 언래핑해서 아래 구문에서 옵셔널 바인딩없이 안전하게 사용할 수 있는 것([weak self]의 기본값은 옵셔널)
            guard let self = self else { return }
            print("뷰컨 클로저 실행")
            // 인덱스를 인자(인수값이라고 하는게 맞나?)로 전달해서 토글 시켜서 save 체크
            // ⭐️(함수 호출시 전달값이 인수이고 함수에서 받는값이 인자로 알고 있는데 보통 인자라고하는듯?)
            self.numberGenManager.setNumbersSave(row: indexPath.row)
            // 하트 fill 설정을 위해 isSaved Bool 값 꺼내서 전달
            senderCell.setButtonStatus(isSaved: self.numberGenManager.getNumbersSaved(row: indexPath.row))
        }
        
        
        
        // ✅ 셀 재사용시마다 인덱스값으로 numbers 배열에 isSaved의 값(Bool)을 전달하면서 해당 인덱스에서 하트를 fill로 할지 normal로 할지 설정함
        //cell.setButtonStatus(isSaved: numberGenManager.getNumbersSaved(row: indexPath.row))
        
        // ✅문자열 넘버를 받아와서 유저디폴츠(즐겨찾기)랑 비교하는 메서드 넣고
        // 있고 없고 bool
        //numberGenManager.isBookmarkNumbers(numbers: number)
        cell.setButtonStatus(isSaved: numberGenManager.isBookmarkNumbers(numbers: number))


        return cell
    }
}

