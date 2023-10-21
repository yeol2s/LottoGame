//
//  NumberSaveManager.swift
//  LottoGame
//
//  Created by 유성열 on 10/13/23.
//

import Foundation

// 번호 저장 매니저
final class NumberSaveManager {
    
    // 최신정보 반영하는 private 변수
    //
    //private var updateNumbers
    
    // 유저디폴츠 객체 변수에 담음
    let userDefaults = UserDefaults.standard
    // ⭐️⭐️⭐️키값으로 데이터를 모으자(이런 키 관련 코드는 나중에 어디 파일 하나에 모아놔야겠지?)
    let saveKey: String = "MyNumbers"
    
    // 유저디폴츠 데이터 임시공간 배열(Int -> String 변경 위함)
    var defaultsTemp: [[String]] = []
    
    // 유저디폴츠에 저장된 번호를 가져와서 타입 변환([[Int]] -> [[String]]) 및 데이터 갱신
    func setSaveData() {
        
        // 일단 유저디폴츠에 데이터를 키를 가지고 가져와서 임시 배열에 문자열로 변경 (문자열 배열 형태로)
        // 그리고 compactMap, map 고차함수를 같이 사용했는데 이유는 [[Int]] 타입이므로 중첩된 배열을 풀어서 작업하기 위함(map함수로 각 내부 배열을 String으로 변환하고 새배열로 결과를 매핑해서 compactMap함수로 중첩 배열을 풀고 각 내부 배열을 nil이 아닌 새로운 배열로 반환)
        if let saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            defaultsTemp = saveData.compactMap{ dataArray in
                return dataArray.map { intValue in
                    return String(intValue)
                }
            }
            //print("문자열 변경 데이터: \(defaultsTemp)")
            print("[[Int]] -> [[String]] 변경 완료")
        }else {
            print("saveData 실패")
        }
    }
    
    //유저디폴츠에 저장된 번호를 삭제한다. (체크 해제시)
    func setRemoveData(row: Int) {
        
        // 일단 유저디폴츠 데이터를 다 가져와서 넣어주고 뷰컨에서 받은 인덱스 번호로 해당 배열 삭제
        if var saveData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            print("삭제 데이터 : \(saveData[row])")
            saveData.remove(at: row)
            print("세이브데이터: \(saveData)")
            
            userDefaults.set(saveData, forKey: saveKey) // 지우고난 배열을 유저디폴츠에 다시 넣어줌
            setSaveData() // 데이터를 다시 넣었으니 [[Int]] -> [[String]]으로 변환위해 setSaveData 함수 호출
        }
        
        // print 확인용
        if let data = userDefaults.array(forKey: saveKey) as? [[Int]] {
            print("삭제후 데이터:\(data)")
        }
    }
    
    
    // 임시 저장 배열 데이터를 가지고 테이블뷰 셀에 보내기 위한 함수
    func getSaveData(row: Int) -> String {
        // 임시 저장 배열에서 꺼내서 배열이 아닌 문자열로만 만들어서 보냄
        let numbers = defaultsTemp[row].joined(separator: "   ")
        return numbers
    }
    
    
    // (유저디폴츠 초기화)번호 저장 초기화
    func resetSavedData() {
        
        defaultsTemp = [] // 임시 저장 배열 초기화
        userDefaults.removeObject(forKey: saveKey) // 유저디폴츠 초기화(키 기준)
        
        print("저장 번호가 초기화되었습니다.")
        if let allData = userDefaults.array(forKey: saveKey) as? [[Int]] {
            print(allData)
        }
    }
    
    
}
