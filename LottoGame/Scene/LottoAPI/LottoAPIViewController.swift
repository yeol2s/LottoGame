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
    
    // 테이블뷰 생성
    private let apiTabelView = UITableView()
    
    let drawDateLabel: UILabel = {
        let label = UILabel()
        label.text = "당첨 번호 조회"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 네트워크 요청 작업 함수
        setupAPI()
        
        setupLabelConstraints()
        setupTableView()
        setupTableViewConstraints()
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        
        apiTabelView.delegate = self
        apiTabelView.dataSource = self
        apiTabelView.rowHeight = 60
        
        apiTabelView.register(LottoAPICell.self, forCellReuseIdentifier: "APICell")
    }
    
    private func setupLabelConstraints() {
        view.addSubview(drawDateLabel)
        drawDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            drawDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            drawDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // 테이블뷰 오토레이아웃
    private func setupTableViewConstraints() {
        
        view.addSubview(apiTabelView)
        apiTabelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            apiTabelView.topAnchor.constraint(equalTo: drawDateLabel.bottomAnchor, constant: 50),
            apiTabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apiTabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apiTabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    // (네트워크)API 요청 셋업
    private func setupAPI() {
        // 네트워킹이 완료되면 result에 LottoInfo 구조체가 올 것?
        // 🔶 Result 타입으로 구현할까?
        networkManager.fetchLotto(round: 1000) { result in
            if let result = result {
                self.lottoInfo = result // result를 lottoInfo 변수에 담아주고
                print("로또 API 데이터가 담겼습니다.")
                dump(self.lottoInfo)
            } else {
                print("로또 API 데이터를 불러오지 못했습니다.")
            }
        }
    }
    
}

extension LottoAPIViewController: UITableViewDelegate {
    
}

// 🔶 당첨 정보 API를 표시하기에 테이블뷰는 적핣하지 않는 것 같다. 테이블뷰는 셀을 가지고 반복작업을 하는거니까.
// 그냥 UILabel을 가지고 뷰를 구성하는 것이 좋겠다.
extension LottoAPIViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = apiTabelView.dequeueReusableCell(withIdentifier: "APICell", for: indexPath) as! LottoAPICell
        return cell
    }
}

