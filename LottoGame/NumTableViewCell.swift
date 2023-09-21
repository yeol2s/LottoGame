//
//  NumTableViewCell.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/17.
//

import UIKit

class NumTableViewCell: UITableViewCell {
    
    // 숫자 출력할 레이블
    var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1234"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false // 자동잡아주는 기능 끔
        
        // 오토레이아웃을 위한 테두리 테스트
        label.layer.borderWidth = 2.0 // 테두리 두깨
        label.layer.borderColor = UIColor.black.cgColor // 테두리 색상
        
        return label
    }()
    
    // 오토레이아웃을 생성자로 설정(스토리보드인 경우 awakeFromNib 함수에서 해주면 되는데 여기선 코드로 구현하는 것이기 때문에 생성자를 사용)
    // init(style) 생성자(애플이 UITableViewCell을 만들때 기본적으로 세팅해주는 생성자를 구현해놓음)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        // 레이블을 셀에 추가
        self.contentView.addSubview(numberLabel)
        
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 레이블 오토레이아웃
    func setLabelConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.heightAnchor.constraint(equalToConstant: 40),
            numberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            numberLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
}
