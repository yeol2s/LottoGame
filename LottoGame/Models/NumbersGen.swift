//
//  NumbersGen.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import Foundation

// 로또 번호 모델
struct NumbersGen {
    
    // 번호 생성시 Index 확인
    //let checkIndex: Int  // 생성할때 값이 들어간다.
    
    // 멤버와이즈 이니셜라이저 사용(기본값 및 생성자 미구현)
    let numbersList: [Int]
    
    // 번호 저장여부를 여기에 저장시킴(테이블뷰 셀 리로드시 불러오기 위해)
    // 번호 저장여부 저장
    var isSaved: Bool = false

}
