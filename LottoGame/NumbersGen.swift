//
//  NumbersGen.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/16.
//

import Foundation

// 로또 번호 모델
struct NumbersGen {
    
    func generateLottoNumbers() -> Array<Int> {
        
        var lottoNumbers: [Int] = []

        // numbers 요소 개수가 6이 될때까지 반복(0부터)
        while lottoNumbers.count < 6 {
            let randomNumber = Int.random(in: 1...45)
            
            // 현재 배열에 랜덤 숫자가 포함되어있는지 여부(포함되어 있다면 추가하지 않음)
            if !lottoNumbers.contains(randomNumber) {
                
                lottoNumbers.append(randomNumber)
            }
        }
        return lottoNumbers
    }
}
