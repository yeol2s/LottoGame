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
    
    let numbersLabelTitle: UILabel = {
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
    
    let firstTicketCountTitle: UILabel = {
        let label = UILabel()
        label.text = "1등 당첨 복권수"
        label.textAlignment = .center
        return label
    }()
    
    // 1등 당첨 복권수
    let firstTicketCount: UILabel = {
        let label = UILabel()
        label.text = "20장"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
}
