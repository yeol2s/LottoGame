//
//  LottoAPIViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/1/23.
//

import UIKit

// 로또 API 네트워크 매니저와 통신하는 뷰컨
class LottoAPIViewController: UIViewController {
    
    // 네트워크 매니저 인스턴스 생성
    private let networkManager = NetworkManager()
    
    // 로또 API를 다루기 위한 구조체 인스턴스 생성
    // 🔶 옵셔널로 선언하는게 좋지?
    private var lottoInfo: LottoInfo?
    
    // 컬러 설정
    // 🔶 컬러 같은 것들 한곳에 모아서 설정한다고 했었지.. 어떻게 하는게 좋음?
    // 그리고 /255.0 쓰는것과, 아래처럼 일일이 속성마다 넣는 것은 안좋지?
    let mintGreenColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
    
    // 타이틀
    private let drawDateLabel: UILabel = {
        let label = UILabel()
        label.text = "당첨 번호 조회"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    // 추첨일
    private let drawDate: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 추첨 회차
    private let drawRound: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨번호 타이틀
    private let numbersLabelTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨번호"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor(red: 0.30, green: 0.80, blue: 0.74, alpha: 1.00) // Turquoise Color
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1~6(보너스)숫자 출력할 레이블
    private let numbersLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.black.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨 복권수 타이틀
    private let firstTicketCountTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 복권수"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨 복권수
    private let firstTicketCount: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨금액 타이틀
    private let firstWinMoneyTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 금액"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 1등 당첨금액
    let firstWinMoney: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // (레이블)스택뷰를 묶을 스택뷰
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 30
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill // .center로 하면 중앙 위치 뷰들은 크기 유지(fill은 모든 뷰가 스택뷰의 크기에 맞게 확장되어 정렬됨)
        view.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.96, alpha: 1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨번호 스택뷰
    private let numbersStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨복권수 스택뷰
    private let ticketStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.89, alpha: 1.00)
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 당첨금액 스택뷰
    private let winMoneyStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.backgroundColor = UIColor(red: 0.87, green: 0.95, blue: 0.89, alpha: 1.00)
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    

    // 레이블 배열
    private lazy var setLabels = [drawDateLabel, drawDate, drawRound, numbersStackView, ticketStackView, winMoneyStackView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mintGreenColor
        setupAPI() // 네트워크 요청 작업 메서드
        setupStackView() // 스택뷰 설정 및 오토레이아웃 메서드 호출
    }
    
    // 스택뷰 설정
    private func setupStackView() {
        numbersStackView.addArrangedSubview(numbersLabelTitle)
        numbersStackView.addArrangedSubview(numbersLabel)
        ticketStackView.addArrangedSubview(firstTicketCountTitle)
        ticketStackView.addArrangedSubview(firstTicketCount)
        winMoneyStackView.addArrangedSubview(firstWinMoneyTitle)
        winMoneyStackView.addArrangedSubview(firstWinMoney)
        
        // 배열로 레이블들을 스택뷰에 올려줌
        for label in setLabels {
            stackView.addArrangedSubview(label)
        }
        // 🔶 스택뷰 먼저 올리고 그다음에 오토레이아웃 하는거 괜찮은건가? (순서에 있어서)
        view.addSubview(stackView) // 스택뷰를 뷰위에 올려줌
        setConstraints() // 오토레이아웃 메서드 호출
    }
    
    // 오토레이아웃 설정 메서드
    private func setConstraints() {
        // 🔶 이건 한번에 하나의 메서드로 묶는게 좋을까?(나중에 유지보수 측면에서 어떤게 나을지?)
        setDrawDateLabelConstraints()
        setNumbersLaebelConstraints()
        setFirstTicketCountConstraints()
        setFirstWinMoneyConstraints()
        setStackViewConstraints()
    }
    
    // ⭐️ 스택뷰 안에 UILabel들은 크게 오토레이아웃을 하지 않았다. 스택뷰는 안에 포함된 요소들을 자동으로 레이아웃하고 정렬하는 UI컨테이너 이므로 스택뷰안에 UILabel또는 다른 뷰를 추가하면 추가된 뷰들을 자동으로 배치하고 크기를 조절함.(스택뷰 안에 스택뷰를 추가해도 마찬가지)
    // 🔶 이렇게 구현하는거 괜찮은지?
    // 레이블 오토레이아웃(레이블들은 스택뷰에 넣으므로 높이, 넓이정도만 설정해줬음
    private func setDrawDateLabelConstraints() { // '타이틀' 레이블 오토레이아웃
        drawDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawDateLabel.heightAnchor.constraint(equalToConstant: 100),
            //drawDateLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setNumbersLaebelConstraints() { // '당첨번호' 타이틀 + 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            numbersLabelTitle.heightAnchor.constraint(equalToConstant: 40),
            numbersLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setFirstTicketCountConstraints() { // '당첨 복권수' 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            firstTicketCount.heightAnchor.constraint(equalToConstant: 30),
            firstTicketCountTitle.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setFirstWinMoneyConstraints() { // '1등 당첨금액' 레이블 오토레이아웃
        NSLayoutConstraint.activate([
            firstTicketCountTitle.heightAnchor.constraint(equalToConstant: 30),
            firstWinMoney.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // 🔶numbersStackView, ticketStackView 스택뷰는 레이아웃 생략하고 메인 스택뷰만 레이아웃함
    // 전체적인 넓이를 위해 좌우 오토레이아웃을 직접 지정했음
    private func setStackViewConstraints() { // '스택뷰' 오토레이아웃
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    // 🔶Date를 가지고 날짜별 회차로 조회가 자동으로 되게끔 설정하는 함수 구현하자.
    // 날짜 + 시간 9시를 기준으로 회차를 바꾸고 리턴하면 될 것이다?
    // 로또 1회차는 2002-12-07
    func calculateLottoRound() -> Int {
        let dateFormatter = DateFormatter() // 데이터포맷터를 사용해서 날짜를 원하는 형식으로 파싱(날짜를 원하는 형식으로 표시하기 위한 문자열?)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let firstDrawDateString = "2002-12-07 21:00:00" // 첫 번째 추첨일 및 시간(1회차)
        guard let firstDrawDate = dateFormatter.date(from: firstDrawDateString) else { return 0 } // 첫번째 추첨 날짜 형식을 Date 객체로 변환하는 메서드(날짜 형식이 맞지 않는 경우 에러 처리)(변환된 결과가 옵셔널 Data? 형식임 그래서 언래핑)
        
        let currentData = Date() // Data 구조체를 사용해서 현재 날짜와 시간을 가져옴
        let calender = Calendar.current // Calender 구조체를 사용해서 현재의 달력을 가져옴
        // ⭐️Set - 집합(컬렉션) (왜 파라미터값을 Set으로 받지?)
        //Calendar.Component.weekOfYear (열거형으로 되어있음 그리고 Set으로 되어있다?? 뭐지)
        //calender.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>, to: <#T##Date#>)
        // 어쨌든 dateComponents(.weekOfYear: from: to:) 함수는 두 날짜 사이의 주차 수를 계산하는 것
        let weeksBetween = calender.dateComponents([.weekOfYear], from: firstDrawDate, to: currentData).weekOfYear ?? 0 // 닐코얼레싱(nil이면 0을 제시)
        // .weekday는 주일
        // 현재 시간이 토요일 저녁 9시 이후인지 확인하여 회차를 결정
        // .component는 요소화 시키는 메서드 (.component(요소, from: Date))
        let currentWeekday = calender.component(.weekday, from: currentData) // 현재 요일 가져옴
        let currentHour = calender.component(.hour, from: currentData) // 현재 시간 가져옴
        
        // (현재날짜와 시간이)토요일인 경우 다음 회차로 이동
        if currentWeekday == 7 {
            if currentHour >= 21 {
                print("토요일 9시 이후: \(weeksBetween + 1)")
                return weeksBetween + 1 // 토요일 저녁 9시 이후라면 다음 회차로 진행
            } else {
                print("토요일 9시 이전: \(weeksBetween)")
                return weeksBetween // 토요일 저녁 9시 이전이라면 현재 회차로 진행
            }
        } else {
            // 토요일이 아닌 경우 다음 회차로 이동
            print("토요일이 아님: \(weeksBetween + 1)")
            return weeksBetween + 1
        }
    }
    
    
    // (네트워크)API 요청 셋업
    private func setupAPI() {
        // 네트워킹이 완료되면 result에 LottoInfo 구조체가 올 것?
        // 🔶 Result 타입으로 구현할까?
        // calculateLottoRound() -> 회차를 리턴
        networkManager.fetchLotto(round: calculateLottoRound()) { result in
            if let result = result {
                self.lottoInfo = result // result를 lottoInfo 변수에 담아주고
                print("로또 API 데이터가 담겼습니다.")
                dump(self.lottoInfo)
                // 🔶 이 부분이 불러오는 로딩이 살짝 발생하는 경우가 있다.
                DispatchQueue.main.async { // UI를 다시그리는 작업은 메인큐에서!
                    self.drawDate.text = result.drawDate
                    self.drawRound.text = result.drwNo + "회차"
                    self.numbersLabel.text = result.numbers + "   +   \(result.bnusNum)"
                    self.firstTicketCount.text = result.firstTicketsCount + "장"
                    self.firstWinMoney.text = result.firstWinMoney + "원"
                }
            } else {
                print("로또 API 데이터를 불러오지 못했습니다.")
            }
        }
    }
    
}

