//
//  NumChoiceList.swift
//  LottoGame
//
//  Created by 유성열 on 2023/10/04.
//

import UIKit

// 번호 저장 셀
// ⭐️ 다른 뷰, 다른 테이블뷰를 만들었으니까 셀도 이렇게 만드는게 맞지?
// ⭐️ 굳이 크게 다른거 없으면 NumTableViewCell을 재사용하는 것이 낫나?
class NumChoiceListTableViewCell: UITableViewCell {
    
    // 숫자 출력 레이블
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 2.0 // 테두리 두깨
        label.layer.borderColor = #colorLiteral(red: 0.9328907132, green: 0.8128731251, blue: 0.6409401298, alpha: 1)
        return label
    }()
    
    // 번호 저장 체크 버튼
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal) // 기본상태 fill
        button.addTarget(self, action: #selector(unChecknumber), for: .touchUpInside)
        return button
    }()

    // 스택뷰 생성
    let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 2
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 📌 뷰컨과 연결할 클로저 선언
    var saveUnCheckButton: ((NumChoiceListTableViewCell) -> ()) = { sender in }
    
    // 오토레이아웃 생성자
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupStackView() // 스택뷰 올리기
        stackViewConstraints() // 스택뷰 오토레이아웃
        
    }
    
    // 필수생성자 구현
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 스택뷰 함수
    private func setupStackView() {
        self.contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(saveButton)
    }
    
    // 스택뷰 오토레이아웃
    private func stackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    // (셀렉터)체크해제(저장된 번호에서 체크해제 했을때 유저디폴츠에서 삭제)
    @objc func unChecknumber() {
        
        // 일단 이건 보류 원래 하트 클릭시 하트해제 되는 그림을 연출하려고 했는데 또 번거로워진다.
        //saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        // 클로저를 통해 뷰컨에 셀 자신 전달
        saveUnCheckButton(self)
    }
    
}
