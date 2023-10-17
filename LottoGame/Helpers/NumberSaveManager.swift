//
//  NumberSaveManager.swift
//  LottoGame
//
//  Created by 유성열 on 10/13/23.
//

import Foundation

// 번호 저장 매니저
final class NumberSaveManager {
    
    // 유저디폴츠 객체 변수에 담음
    let defaults = UserDefaults.standard
    // ⭐️⭐️⭐️키값으로 데이터를 모으자
    // 불가능해.. 유저디폴츠는 키하나에 배열이 여러개 들어갈 수 없고 값 하나이거나 배열하나까지만 가능..
    
    // ⭐️이 부분도 모델을 따로 만들어야 하나? (결국 얘는 문자열 배열로 바꿔야함)
    // 디폴츠 데이터 가져와서 담을 딕셔너리
    var numbersSaveData: [Int: [Int]] = [:] // 키(Int), 값(Int배열)
    
    // 디폴츠 데이터 Int -> String으로 변환해서 담을 배열
    //var numbersSaveDataString: [String] = []
    // 문자열 배열로 저장할 번호 저장 구조체
    var numbersSave: [NumbersSave] = []
    

    // 유저디폴츠에 저장된 번호를 가져온다(셀에 전달하기 위함)
    func setSavedData() {
    
        // 일단 유저디폴츠에 저장되어있는 데이터를 전부 가져온다. (딕셔너리로 던져줌)[String(키): Any(값)]
        // 이게 무슨 쓸데없는 데이터들이 15개정도가 있네(그래서 아래처럼 반복문으로 정수값 변환가능한 key만 가져오는 코드를 구현함)(이게 맞나?)
        let allData = defaults.dictionaryRepresentation()
        // 이걸로하자
        //defaults.object(forKey: <#T##String#>)
        
        var arrayInt: Array<Int> = [] // 정수 담아놓을 배열
        
        for (key, value) in allData {
            // ⭐️ 이렇게 Array<Any> 타입캐스팅 해서넣는거 괜찮은가?(번호 배열임)
            // 키를 정수로 바꾸고 값은 Any 타입이므로 배열로 타입캐스팅해서 딕셔너리 변수에 넣음
            // Any타입말고 왜 Int로는 안담길까?
            if let intKey = Int(key), let anyValue = value as? Array<Any> { // 키가 정수로 바뀌는 경우, 밸류가 배열<Any>로 바뀌는 경우 바인딩
                // anyValue에 숫자 배열을 한번더 반복문 돌려서 Int로 타입캐스팅해서 따로 배열에 전달해줌
                for value in anyValue { // 1. (중첩반복문) (anyValue)Array<any>가 한번씩 돌고
                    print("value: \(value)")
                    // ⭐️ 정수를 Any->Int가 아닌 String으로 바로 변환이 안됨
                    if let intValue = value as? Int { // Any -> Int형으로 타입캐스팅되는 경우만
                        arrayInt.append(intValue) // 2. 함수에 선언된 배열에 담아놓고
                    }
                }
                numbersSaveData[intKey] = arrayInt // 3. 딕셔너리에 전달(키마다 반복)
                arrayInt = [] // 4. 전달이되면 함수내 배열은 초기화
                print("array:\(numbersSaveData)")
            }
        }
        // 함수를 호출해서 여기서 문자열로 바꿔서 NumbersSave 구조체 배열에 문자열로 저장 시킴
        numbersStringArrayChange()
    }
    
    // numberSaveData 딕셔너리에 정수들을 문자열로 변환(셀에 text에 전달하기 위함)
    private func numbersStringArrayChange() {
        // 📌내 생각 (구현 예정)
        // 음.. 일단 모델을 가지고 모델에 배열로 해서 저장을 시켜야겠다. (딕셔너리형, 배열형 두개로)
        // 그리고 여기서 딕셔너리 꺼내서 문자열로 변환해서 배열에 저장시켜야 할듯 ㅇㅋ
        var numbersSaveDataString: [String] = []

        // 일단 numberSaveData 딕셔너리의 모든 value를 꺼내서 value를 Int->String 으로 변경
        // 값이 결국엔 [번호배열]로 묶여진것이 1개의 값이기 때문에 저장된 번호들이 2개면 2번 반복되는 것
        for (_, value) in numbersSaveData {
            numbersSaveDataString = value.map { String($0) }
            // 구조체 배열은 append를 할때 이렇게 인스턴스 생성해서 넣어야 하는 것
            //numbersSave.append(NumbersSave(value: numbersSaveDataString))
            numbersSave.append(.init(value: numbersSaveDataString)) // ⭐️타입추론
        }
//        print("numberSave 배열: \(numbersSave[0].savedNumbers)")
//        print("numberSave 배열: \(numbersSave[1].savedNumbers)")
    }
    
    // 저장된 번호 셀로 보냄
    func getNumbersStringArray(row: Int) -> String {
        return numbersSave[row].value.joined(separator: "   ")
    }
    
    // (유저디폴츠 초기화)번호 저장 초기화
    func resetSavedData() {
        // 전체 데이터를 가져와서 초기화하는 방법인데 이건 모든 데이터가 지워지니까 뭔가 불안하다.
        // 📌 그래서 저장된 번호 가져오는 방식과 비슷하게 구현할 예정
        // ⭐️⭐️⭐️ 키값으로 지우자(nil 세팅)
        let appDomain = Bundle.main.bundleIdentifier! // 현재 앱의 식별자
        UserDefaults.standard.removePersistentDomain(forName: appDomain) // UserDefaults의 모든 데이터를 제거하는 메서드
        
        numbersSaveData = [:] // 디폴츠 데이터 담은 딕셔너리도 초기화
        numbersSave.removeAll() // 번호 저장 구조체 배열 전체 초기화
    }
    
    
}
