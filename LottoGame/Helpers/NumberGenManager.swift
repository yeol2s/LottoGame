//
//  NumberGenManager.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/22.
//

import Foundation

// 관리자 역할 및 데이터를 추가, 삭제 위함(매니저)
final class NumberGenManager {
    
    // 유저디폴츠 사용을 위한 변수 선언
    let defaults = UserDefaults.standard
    
    // 번호 배열로 생성되면 저장(배열을 -> 또 배열로 저장)
    private var numbers: [NumbersGen] = []
    
    // 번호 생성 버튼 클릭시 번호 저장되는 배열
    private var lottoNumbers: [Int] = []
    
    // ✅필요 없음
    // 번호 저장 여부 배열 저장(셀 재사용시 섞이지 않기 위한 인덱스로 보관하기 위함)
    //var saveStates = [Bool]()
    
    
    // 번호 생성하는 함수
    func generateLottoNumbers() -> Bool {
        
        // 번호가 10개이상 생성되지 않게
        guard numbers.count <= 10 else {
            print("현재 생성된 번호가 10개이므로 더 이상 생성할 수 없습니다.")
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
        //print("numbers 모델(구조체) 내용 확인 : \(numbers)")
        //NumbersGen.checkIndex += 1 // 번호 생성마다 (타입저장속성) Index를 1씩더함
        return true
    }
    
    // 전체 번호 배열 리스트 얻기
    func getNumbersList() -> [NumbersGen] {
        return numbers
    }
    
    // 번호 리셋을 위한 함수
    func resetNumbers() {
        numbers = [] // 초기화
    }
    
    // 전체 번호(정수) 배열을 문자열로 변환해서 얻기
    func getNumberStringChange(row: Int) -> String {
        // numbers 구조체 배열의 row로 인덱스 접근해서 가져옴
        let numStringChange = numbers[row]
        // 가져온 numbers 구조체 배열을 map함수를 통해 문자열 변환
        // 문자열로 받아올 것이고 파라미터 생략이니까 String 타입 명시
        let numStrig = numStringChange.numbersList.map { String ($0) }
        // 공백으로 분리해서 각각 문자열로 반환
        return numStrig.joined(separator: "   ")
    }
    
    // ⭐️ 이 set get을 서브스크립트로 구현 가능한가? 이렇게 구현하는게 올바른가
    // ✅ 테이블뷰에서 번호 저장 클릭시 인덱스를 가지고 numberGen의 isSaved를 토글 시킴
    // ⭐️ rowValue같이 상수로 선언해도 누를때마다 값이 변경이 가능한 것은 함수는 스택에서 실행되고 사라지고 버튼을 다시 눌렀을때 다시 생겨나기 때문이지?
    func setNumbersSaved(row: Int) {
        //saveStates.append(true) // 세이브 여부(Bool) 배열 저장 위함(필요 없음)
        numbers[row].isSaved.toggle() // 배열 인덱스로 접근해서 토글로 true로 변경
        print("토글 index: \(row), isSaved 상태: \(numbers[row].isSaved)")
        
        // row값을 문자열로 변경(userDefaults 키값 사용 위해)해서 담아놓음
        let rowValueKeyChanged: String = String(row)
//        print("userDefaults 할당 row값: \(rowValue)")
//        print("저장되는 번호 확인: \(numbers[row].numbersList)")

        //📌 여기서 유저디폴츠를 사용해서 번호 저장시키는게 맞을듯(함수를 하나 구현해서 호출하고 Bool 타입을 인자값으로 전달시켜서 저장 / 삭제를 할 수 있게끔
        //⭐️ 이렇게 저장/삭제를 함수로 하나씩 나누는 것 괜찮은가?
        // isSaved의 상태가 true일때 userDefaults에 저장
        if numbers[row].isSaved {
            userSaveDataAdd(row: row, key: rowValueKeyChanged) // 인덱스값, 키값 전달
        } else {
            userSavedDataRemove(key: rowValueKeyChanged)
        }
        
        // 데이터 상태 확인
        // [Any]? 타입으로 리턴하므로 옵셔널 바인딩
        if let checkSaved = defaults.array(forKey: rowValueKeyChanged) {
            print("현재 \(row)번 인덱스에 저장된 데이터는: \(checkSaved)")
        } else {
            print("현재 \(row)번 인덱스에 데이터가 없습니다.")
        }
        
        
    }
    
    // ✅ numbers 배열에 인덱스값으로 접근해서 isSaved의 상태가 true인지 false인지 확인
    func getNumbersSaved(row: Int) -> Bool {
        let isSaved = numbers[row].isSaved
        return isSaved
    }
    
    // 📌 여기서 유저디폴츠 번호 저장 / 삭제 함수를 구현해서 setNumberSaved와 연결하자.
    // (번호 저장)저장 함수
    private func userSaveDataAdd(row: Int, key: String) {
        defaults.set(numbers[row].numbersList, forKey: key) // 데이터 추가
    }
    
    // (번호 저장)삭제 함수
    private func userSavedDataRemove(key: String) {
        defaults.removeObject(forKey: key) // 데이터 삭제(key값 기준으로 삭제)
    }
    
    
    
    // 서브스크립트로 만듬(레이블에 번호 인덱스를 통해 보내주기 위해)
    // NumberGen 구조체에 저장되어있는 데이터에 접근하기 위해서
//    subscript(index: Int) -> NumbersGen {
//        get {
//            return numbers[index]
//        }
//        // set은 굳이 필요없어서 주석처리
////        set {
////            numbers[index] = newValue
////        }
//    }
}
