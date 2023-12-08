//
//  AddNumbersCollectionViewCell.swift
//  LottoGame
//
//  Created by 유성열 on 12/7/23.
//

import UIKit

// 저장 번호 직접 추가하는 컬렉션뷰셀
final class AddNumbersCollectionViewCell: UICollectionViewCell {
    
    // 번호 보여주는 label
    //let numberLabel = UILabel()
    
    // (단일 번호)공 모양 변환 인스턴스 생성
    private let numberBallView = NumberBallView()
    
    // 코드로 작성해서 생성자로 오토레이아웃
    // frame: CGRect을 사용하는 이유는 해당 셀의 초기 프레임을 설정하기 위함(셀이 화면에 표시될 때 초기 위치와 크기를 정함)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    // 번호 나열하는 레이블 오토레이아웃
//    private func setupUIConstraints() {
//        numberLabel.textAlignment = .center
//        self.contentView.addSubview(numberLabel) // 레이블을 셀 하위뷰로 추가
//        numberLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            numberLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            numberLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
//        ])
//    }
    
    // 번호 나열하는 레이블 오토레이아웃(수정 테스트)
    private func setupUIConstraints() {
        //numberLabel.textAlignment = .center
        self.contentView.addSubview(numberBallView) // 레이블을 셀 하위뷰로 추가
        numberBallView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberBallView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            numberBallView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
//    private func setupBallViewConstraints() {
//        numberLabel.addSubview(numberBallView)
//        numberBallView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            numberBallView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
//            numberBallView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor)
//        ])
//    }
    
    
    // 일단 번호를 받아서 레이블에 표시하는 것인데.. 수정필요.
    func configure(_ number: Int) {
        numberBallView.displayNumber(number)
        //numberLabel.text = number
    }
    
}
