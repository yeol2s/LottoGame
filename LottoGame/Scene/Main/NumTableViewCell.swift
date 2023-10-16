//
//  NumTableViewCell.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/17.
//

import UIKit

// 테이블뷰 셀
// ⭐️ 얘의 폴더 SubViews는 왜 뭔가 아이콘이 살짝 다른 이유?
class NumTableViewCell: UITableViewCell {
    
    
    // 숫자 출력할 레이블
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        //label.translatesAutoresizingMaskIntoConstraints = false // 자동잡아주는 기능 끔
        
        // 레이블 둥글게
        label.layer.cornerRadius = 5
        label.clipsToBounds = true // 경계를 벗어나는 내용을 잘라내는 것인데(masksToBounds속성으로도 대체 가능)
        
        // 오토레이아웃을 위한 테두리 테스트

        label.layer.borderWidth = 2.0 // 테두리 두깨
        label.layer.borderColor = #colorLiteral(red: 0.7499064803, green: 0.9831754565, blue: 0.9550266862, alpha: 1)
        //label.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상(UIColor로 색상을 생성해서 CGcolor로 변환하는 코드)
        
        
        return label
    }()
    
    // 번호 저장 버튼
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal) // 하트아이콘 넣기
        button.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .clear
        // ⭐️addTarget에서 NumTableViewCell을 메타타입으로 하라고 하는 이유?(그럼 에러남)
        // 그리고 번호저장버튼을 위해 addTarget을 여기에 구현하는게 올바른지? 뷰컨 테이블뷰 메서드에 넣어야 하는거 아니고?
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        //button.layer.borderWidth = 1.0
        //button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return button
    }()
    
    // '숫자 레이블' + '번호 저장 버튼'묶기 위한 스택뷰 생성
    // ⭐️ 번호 선택 박스가 정사각형이였으면 좋겠는데 그게 잘 안되네
    let stackView: UIStackView = {
        let view = UIStackView() // frame(크기기준)과, arrangedSubviews(배열)로도 생성가능
        view.spacing = 2 // 스택뷰 내부의 간격
        view.axis = .horizontal // axis: 축 (묶을때 가로, 세로 방향 결정)(vertical(세로-수직), horizontal(가로-수평)
        view.distribution = .fill // 크기 분배 어떻게 할건지?
        view.alignment = .fill // 정렬(fill은 완전히 채우는 정렬)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ✅ 번호저장 버튼을 위한 클로저 저장
    // 뷰컨에 있는 클로저를 저장할 예정(셀(자신)을 전달)
    // 이 클로저는 뷰컨에서 동작
    // ⭐️ 함수타입 선언을 이렇게 괄호 안에 넣는게 정석이야?
    var saveButtonPressed: ((NumTableViewCell) -> ()) = { sender in }
    
    // 오토레이아웃을 생성자로 설정(스토리보드인 경우 awakeFromNib 함수에서 해주면 되는데 여기선 코드로 구현하는 것이기 때문에 생성자를 사용)
    // init(style) 생성자(애플이 UITableViewCell을 만들때 기본적으로 세팅해주는 생성자를 구현해놓음)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        //self.contentView.addSubview(numberLabel) // 레이블을 셀에 추가
        //setLabelConstraints() // 레이블 오토레이아웃(스택뷰 완성되면 삭제할 것)
        
        setupStackView() // 스택뷰 올리기
        stackViewConstraints() // 스택뷰 오토레이아웃
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 레이블 오토레이아웃(버튼과 레이블로 묶었으니 일단 보류 - 스택뷰 완성되면 삭제 예정)
//    func setLabelConstraints() {
//        NSLayoutConstraint.activate([
//            numberLabel.heightAnchor.constraint(equalToConstant: 40),
//            numberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
//            numberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
//            numberLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
//        ])
//    }
    
    // 스택뷰
    private func setupStackView() {
        self.contentView.addSubview(stackView) // 스택뷰를 셀에 올림
        
        // 셀에서는 self.addSubview보다 self.contentView.addSubview로 잡는게 더 정확함 ⭐️
        // 스택뷰위에 레이블, 버튼을 배열형태로 올린다.
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
    
    // ✅
    // 번호저장 버튼 눌렸을때 셀렉터
    @objc private func saveButtonTapped() {
        print("번호저장 버튼이 셀에서 눌렸습니다.")
        saveButtonPressed(self)
    }
    
    // ✅
    // 번호저장 버튼 설정
    func setButtonStatus(isSaved: Bool) {
        if isSaved {
            saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
}
