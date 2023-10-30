//
//  NumberGenManager.swift
//  LottoGame
//
//  Created by 유성열 on 2023/09/22.
//

import Foundation


enum SaveError: Error {
    case overError
    case duplicationError
    
}

// 번호 생성 매니저
// 관리자 역할 및 데이터를 추가, 삭제 위함(매니저)
final class NumberGenManager {
    
    // 유저디폴츠 사용을 위한 변수 선언
    private let userDefaults = UserDefaults.standard
    // 유저디폴츠 번호저장 키
    private let saveKey: String = "MyNumbers"
    
    // 유저디폴츠 데이터 임시공간 배열(저장 추가시 사용됨)
    private var defaultsTemp: [[Int]] = []
    
    // 번호 배열로 생성되면 저장(배열을 -> 또 배열로 저장)
    private var numbers: [NumbersGen] = []
    
    // 번호 생성 카운트(중복값 처리)
    //private var count: Int = 0

    
    // 번호 생성하는 함수
    func generateLottoNumbers() -> Bool {
        // 번호 생성 버튼 클릭시 번호 저장되는 배열
        var lottoNumbers: [Int] = []
        
        // 번호가 10개이상 생성되지 않게
        // 처음 실행할때는 카운트가 무조건 0개로 시작하니까 9를 기준으로 했다.
        guard numbers.count <= 9 else {
            print("현재 생성된 번호가 10개이므로 더 이상 생성할 수 없습니다.")
            return false
        }
        print("생성 카운트:\(numbers.count)")
        
        // lottoNumbers 요소 개수가 6이 될때까지 반복(0부터)
        while lottoNumbers.count < 6 {
            
            let randomNumber = Int.random(in: 1...45)
            
            // 현재 배열에 랜덤 숫자가 포함되어있는지 여부(포함되어 있다면 추가하지 않음)
            if !lottoNumbers.contains(randomNumber) {
                lottoNumbers.append(randomNumber)
            }
        }
        
        // ⭐️ 이렇게 하는거 괜찮은 코드?
        // 혹시나 중복된 값이 나오면 처리
        // 테스트 코드
        print(numbers.isEmpty)
        if !numbers.isEmpty {
            for num in numbers {
                print("numbers:\(num)")
                if num.numbersList == lottoNumbers.sorted() {
                    print("중복입니다.")
                    lottoNumbers = []
                    repeat {
                        while lottoNumbers.count < 6 {
                            
                            let randomNumber = Int.random(in: 1...45)
                            
                            // 현재 배열에 랜덤 숫자가 포함되어있는지 여부(포함되어 있다면 추가하지 않음)
                            if !lottoNumbers.contains(randomNumber) {
                                lottoNumbers.append(randomNumber)
                            }
                        }
                    } while num.numbersList == lottoNumbers.sorted()
                }
            }
        }
        
        // 구조체 배열은 append를 할때 이렇게 인스턴스 생성해서 넣어야 하는 것
        numbers.append(NumbersGen(numbersList: lottoNumbers.sorted()))
        //numbers.append(.init(numbersList: lottoNumbers.sorted()))
        
        
        
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
        numbers.removeAll() // 초기화
        defaultsTemp.removeAll() // 임시배열 초기화
    }
    
    // 전체 번호(정수) 배열을 문자열로 변환해서 얻기
    func getNumberStringChange(row: Int) -> String {
        print("번호가 생성되었습니다.")
        // numbers 구조체 배열의 row로 인덱스 접근해서 가져옴
        let numStringChange = numbers[row]
        // 가져온 numbers 구조체 배열을 map함수를 통해 문자열 변환
        // 문자열로 받아올 것이고 파라미터 생략이니까 String 타입 명시
        let numStrig = numStringChange.numbersList.map { String ($0) }
        // 공백으로 분리해서 각각 문자열로 반환
        return numStrig.joined(separator: "   ")
    }
    
    // ❗️(수정중 코드)
    // ✅ 테이블뷰에서 번호 저장 클릭시 인덱스를 가지고 numberGen의 isSaved를 토글 시킴
    // ⭐️ rowValue같이 상수로 선언해도 누를때마다 값이 변경이 가능한 것은 함수는 스택에서 실행되고 사라지고 버튼을 다시 눌렀을때 다시 생겨나기 때문이지?
    func setNumbersSave(row: Int) -> Result<Bool, SaveError> {
        
        // 10개 이상 저장안되게(10개 이상일시 false 리턴)
        // if let 바인딩이니까 유저디폴츠 데이터가 없으면 이 바인딩은 nil이 되고 토글부터 실행됨(고로 저장된 번호없이 첫 실행시는 토글(저장)이 먼저 진행되는 것)
        if let dataCount = userDefaults.array(forKey: saveKey) as? [[Int]] {
            if dataCount.count >= 10 {
                print("저장된 번호가 10개 이상입니다.")
                return Result.failure(SaveError.overError)
            }
            // 📌📌 중복 저장 안되게(열거형으로 구현해보자)
            if dataCount.contains(numbers[row].numbersList) {
                print("중복입니다.")
                return Result.failure(SaveError.duplicationError)
            }
            print("저장된 번호가 \(dataCount.count + 1)개 입니다.")
        }

        
        numbers[row].isSaved.toggle() // 배열 인덱스로 접근해서 토글로 true로 변경
        print("토글 index: \(row), isSaved 상태: \(numbers[row].isSaved)")
        
        // isSaved의 상태가 true일때 userDefaults에 저장
        if numbers[row].isSaved {
            userSaveSelectDataAdd(row: row)
        } else {
            // isSaved의 상태가 false일때는 유저디폴츠에서 삭제(하트 해제)
            userSavedSelectRemove(row: row)
        }
        
        return Result.success(true)
    }
    
    // ✅ numbers 배열에 인덱스값으로 접근해서 isSaved의 상태가 true인지 false인지 확인
    func getNumbersSaved(row: Int) -> Bool {
        let isSaved = numbers[row].isSaved
        return isSaved
    }
    
    // 여기서 유저디폴츠 번호 저장 / 삭제 함수를 구현해서 setNumberSaved와 연결하자.
    // ⭐️⭐️⭐️ 값 중복으로 저장되는 것도 막아야 한다. ⭐️⭐️⭐️
    // (번호 저장)저장 함수(하트 선택)
    private func userSaveSelectDataAdd(row: Int) {
        
        // 📌 테스트 코드
        defaultsTemp.removeAll() // 임시배열 초기화
        
        // 키를 통해 디폴츠 값을 한번 불러와서 임시배열에 넣고(저장된 번호가 없을 수 있으니 if 바인딩)
        // obejct를 써도 되지만 얘는 Any? 타입이고 array로 가져오면 Array<Any>? 타입으로써 바로 배열로 가져온다.
        if let savedData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            defaultsTemp = savedData // ⭐️Copy-On-Write 발생??(값이 바뀌기 전까지?)
            print("현재 유저디폴츠의 배열들: \(savedData)")
        } else {
            print("현재 유저디폴츠에는 저장된 번호가 없습니다.")
        }
        
        // 저장이 선택된 번호의 배열도 임시 배열에 추가로 넣고[[Int]]
        // *그냥 단순 추가해서 유저디폴츠에 넣는 용도로 변경됨
        defaultsTemp.append(numbers[row].numbersList)
        //print("defaultsTemp: \(defaultsTemp)")
        
        // 더해진 값들을 디폴츠에 다시 넣는다.[[Int]]
        userDefaults.set(defaultsTemp, forKey: saveKey)
        
        // print용
        if let savedData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            print("(체크)변경된 유저디폴츠의 값:\(savedData)")
        }
    }
    
    // (번호 저장)삭제 함수(하트 선택 해제)
    private func userSavedSelectRemove(row: Int) {
        
        // 일단 유저디폴츠 데이터를 배열로 다 가져와서 담고
        if let allData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            // 반복문을 돌려서 밸류값을 현재 저장 해제한 번호와 비교
            for value in allData {
                if numbers[row].numbersList == value {
                    print("중복되는값:\(value)")
                    // 중복되는 값인 i를 firstIndex로 몇번 인덱스인지 찾음(임시배열에서)
                    //if let tempIndex = allData.firstIndex(of: value) {
                    //📌 테스트코드
                    if let tempIndex = defaultsTemp.firstIndex(of: value) {
                        print("임시배열에서 삭제되었습니다. \(tempIndex)")
                        defaultsTemp.remove(at: tempIndex) // 인덱스로 데이터 배열 삭제
                    }
                }
            }
            userDefaults.set(defaultsTemp, forKey: saveKey) // 삭제된 상태의 임시배열을 다시 유저디폴츠에 넣어줌
            
            // print용
            if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
                print("(체크해제)변경된 유저디폴츠의 값:\(saveData)")
            }
        }
    }
    
    // 메인화면의 번호를 유저디폴츠와 현재 데이터와 비교해서 있는지 없는지 확인
    // 메인화면에 하트표시후 번호저장 화면에서 하트를 제거했을때 메인화면에서도 해당 번호의 하트가 지워지도록.
    // 파라미터로 현재 셀의 번호를 받는다.(인덱스 기준 받는 번호가 달라짐)
    func isBookmarkNumbers(numbers: String) -> Bool {
        print("isBook 실행")
        if let allData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            for value in allData {
                // mpa은 배열을 새롭게 매핑해서 새로운 배열로 리턴
                //print("벨류:\(value)")
                let changeData = value.map{ String($0) }
                // joined는 배열을 -> 하나의 문자열로 반환
                if numbers == changeData.joined(separator: "   ") {
                    return true
                }
            }
        }
        return false
    }
    
    func isBookmarkUnsavedToggle(row: Int) {
        numbers[row].isSaved = false
        print("\(numbers[row].numbersList)의 토글이 완료되었습니다.")
    }
}
