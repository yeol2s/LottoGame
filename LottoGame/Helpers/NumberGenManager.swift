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
    
    // 번호 생성 버튼 클릭시 번호 저장되는 배열
    private var lottoNumbers: [Int] = []
    
    // 번호 생성하는 함수
    func generateLottoNumbers() -> Bool {
        
        // 번호가 10개이상 생성되지 않게
        guard numbers.count <= 10 else {
            print("10개를 넘었습니다.")
            return false
        }
        
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
        // print(numbers[NumbersGen.checkIndex].numbersList)
        // print("Index 번호 : \(NumbersGen.checkIndex)") // 0부터 시작
        print("numbers 모델(구조체) 내용 확인 : \(numbers)")
        //NumbersGen.checkIndex += 1 // 번호 생성마다 (타입저장속성) Index를 1씩더함
        return true
    }
    
    // 전체 번호 배열 리스트 얻기
    func getNumbersList() -> [NumbersGen] {
        return numbers
    }
    
    // ⭐️ 이건 일단 보류(레이블에 번호 표시 보내주기 위한)
    // 전체 번호(정수) 배열을 문자열로 변환해서 얻기
    func getNumberStringChange(row: Int) -> String {
//        let numStringChange = lottoNumbers.map { String($0) } // 하나씩 문자열로 변경해서 배열로 리턴(map)
//        let numStringChanged = numStringChange.joined(separator: ", ")
//        return numStringChanged
        
        let numStringChange = numbers[row]
        
        let numStrig = numStringChange.numbersList.map { String ($0) }
        
        return numStrig.joined(separator: ", ") // ,로 나눠서 각각 문자열로 반환
    }
    
    // ⭐️ 서브스크립트로 만들어봄(레이블에 번호 인덱스를 통해 보내주기 위해)
    // NumberGen 구조체에 저장되어있는 데이터에 접근하기 위해서
    subscript(index: Int) -> NumbersGen {
        get {
            return numbers[index]
        }
        set {
            numbers[index] = newValue
        }
    }
}
