//
//  LottoAPIViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/1/23.
//

import UIKit

// 로또 API 네트워크 매니저와 통신하는 뷰컨
class LottoAPIViewController: UIViewController {
    
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
    
}

extension LottoAPIViewController: UITableViewDelegate {
    
}

extension LottoAPIViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4  // 🔶 이 부분은 나중에 메서드 호출같은 것으로 변경할 것
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = apiTabelView.dequeueReusableCell(withIdentifier: "APICell", for: indexPath) as! LottoAPICell
        return cell
    }
    
    
}

