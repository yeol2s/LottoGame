//
//  LottoAPICell.swift
//  LottoGame
//
//  Created by 유성열 on 11/1/23.
//

import UIKit

// API 정보받아서 표시할 테이블뷰 셀
// 1~6(보너스)번호, 1등 당첨금, 1등 당첨 복권수
class LottoAPICell: UITableViewCell {
    
    private let numbersLabelTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨번호"
        label.textAlignment = .center
        return label
    }()
    
    // 1~6(보너스)숫자 출력할 레이블
    let numbersLabel: UILabel = {
        let label = UILabel()
        label.text = "1 2 3 4 5 6 + 10"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    private let firstTicketCountTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 복권수"
        label.textAlignment = .center
        return label
    }()
    
    // 1등 당첨 복권수
    let firstTicketCount: UILabel = {
        let label = UILabel()
        label.text = "0장"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    // 레이블 묶을 스택뷰
    let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 레이블 배열
    private lazy var setLabels = [numbersLabelTitle, numbersLabel, firstTicketCountTitle, firstTicketCount]
    
    // 오토레이아웃 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 스택뷰 함수
    private func setupStackView() {
        self.contentView.addSubview(stackView)
        for label in setLabels { // 배열로 레이블들을 스택뷰에 넣어준다.
            stackView.addArrangedSubview(label)
        }
    }
    
    // 스택뷰 오토레이아웃
    private func stackViewConstaraints() {
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    
}
