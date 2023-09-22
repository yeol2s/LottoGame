//
//  NumberGenManager.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/22.
//

import Foundation

// 관리자 역할 및 데이터를 추가, 삭제 위함(매니저)
final class NumberGenManager {
    
    // 번호 배열로 생성되면 저장(배열을 -> 또 배열로 저장)
    private var numbers: [NumbersGen] = []
    
    private var lottoNumbers: [Int] = []
    
        func generateLottoNumbers() {
    
            lottoNumbers = []
    
            // numbers 요소 개수가 6이 될때까지 반복(0부터)
            while lottoNumbers.count < 6 {
                let randomNumber = Int.random(in: 1...45)
    
                // 현재 배열에 랜덤 숫자가 포함되어있는지 여부(포함되어 있다면 추가하지 않음)
                if !lottoNumbers.contains(randomNumber) {
    
                    lottoNumbers.append(randomNumber)
                }
            }
            numbers.append(NumbersGen(numbersList: lottoNumbers.sorted()))
            print(numbers[NumbersGen.checkIndex].numbersList)
            print("Index 번호 : \(NumbersGen.checkIndex)")
            NumbersGen.checkIndex += 1 // 번호 생성마다 (타입저장속성) Index를 1씩더함
        }
}
