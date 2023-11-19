//
//  NetworkManager.swift
//  LottoGame
//
//  Created by 유성열 on 11/1/23.
//

import Foundation

// 서버에서 주는 데이터 형태(로또 API)
// 내가 만들고 싶은 데이터형태로도 만들수 있지만 구조체를 하나 더 만들어야함(서버에서 주는 데이터형태는 변형 불가능)
struct Welcome: Codable {
    let returnValue: String // "success"? 이건 뭐지 뭐 아무튼 결과값인듯하다.
    let drwNoDate: String // 발표 날짜
    let firstWinamnt: Int // 1등 1개당 당첨금
    let firstPrzwnerCo: Int // 1등 당첨 복권수
    let drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6, bnusNo: Int // 1~6번호+보너스 번호
//    let drwtNo6, drwtNo4, : Int
//    let drwtNo5, bnusNo, firstAccumamnt, drwNo: Int
//    let drwtNo2, drwtNo3, drwtNo1: Int
}

// 내가 만들고 싶은 데이터형태(분석해서 데이터 받아서 앱에서 실제 사용)
struct LottoInfo {
    let drawDate: String // 발표 날짜
    let firstMoney: Int // 1등 1개당 당첨금
    let firstTicketsCount: Int // 1등 당첨 복권수
    //let num1, num2, num3, num4, num5, num6: Int // 1~6 번호
    let numbers: [Int] // 1 ~ 6 번호 배열로
    let bnusNum: Int // 보너스 번호
    
    // 생성자로 넣어줌? (당첨날짜, 1등당첨금액, 1등당첨복권수)
    // 원래 굳이 생성자 안해도 멤버와이즈 이니셜라이저로 생성자가 자동 구현되는데 일단 생성
    init(drawData: String, firstMoney: Int, firstTicketsCount: Int, numbers: [Int], bnusNum: Int) {
        self.drawDate = drawData
        self.firstMoney = firstMoney
        self.firstTicketsCount = firstTicketsCount
        self.numbers = numbers // 배열로 받아올 것
        self.bnusNum = bnusNum
    }
    
}

// 네트워크 매니저
struct NetworkManager {
    
    // 로또 회차별 URL(key) 따로없음
    let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    
    // URL 통신 함수 호출(데이터형태를 전달한다?)
    // round는 회차
    func fetchLotto(round: Int, completion: @escaping (LottoInfo?) -> Void) {
        let urlString = "\(lottoURL)\(String(round))"
        print("통신하는 주소 : \(urlString)")
        performRequest(with: urlString) { lottoInfo in
            completion(lottoInfo) // 컴플리션핸들러로 performRequest로 부터 결과를 전달받아서 또 전달
        }
    }
    
    // 실제 URL 통신해서 결과를 전달하는 함수(실제 작업들이 여기서 이루어짐)
    private func performRequest(with urlString: String, completion: @escaping (LottoInfo?) -> Void ) {
        print(#function) // 함수실행 확인 코드
        
        // 1. URL 구조체 만들기
        guard let url = URL(string: urlString) else { return }
        
        // 2. URLSession 만들기(네트워킹을 하는 객체 - 브라우저 같은 역할)
        let session = URLSession(configuration: .default)
        
        // 3. 세션에 작업 부여(네트워킹은(dataTask)은 비동기적으로 동작)
        let task = session.dataTask(with: url) { (data, response, error) in
            // 일단 에러의 경우부터 처리
            if error != nil { // error가 nil이 아니면 에러발생
                print("URL Session 에러 발생")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                completion(nil) // 데이터가 바인딩에 실패했다면(성공하면 가드문 아래로 진행)
                return
            }
            
            // 데이터 분석하기
            if let lottoInfo = self.parseJSON(safeData) {                completion(lottoInfo) // 파싱에 성공하면 컴플리션핸들러로 로또 구조체를 던져줌
            } else {
                completion(nil)
            }
            
            
        }
        task.resume() // task 작업 시작(일시정지된 상태로 작업이 시작됨)(한마디로 작업 활성화-작업시작)
        // 중단이 필요하면 .suspend() 메서드를 사용할 수 있음
    }
    
    // JSON 형태의 데이터 분석하는 함수(JSONDecoder를 사용해서)(파싱이라고 함)
    // 데이터를 가지고 LottoInfo 구조체 형태로 리턴해줌
    private func parseJSON(_ lottoData: Data) -> LottoInfo? {
        print(#function)
        
        let decoder = JSONDecoder() // 일단 JSONDecoder 객체를 생성해주고
        
        // JSONDecoder의 decode 메서드는 디코딩하는 메서드로 에러가 발생할 수 있으므로 do-catch문을 반드시 사용하는 것이 좋다.
        do {
            let decodeData = try decoder.decode(Welcome.self, from: lottoData) // lottoData(JSON?)를 하나하나 Welcome(받아온 데이터형태)로 바꾼 다음 decodeData에 할당?
            
            // 일단 번호는 배열로 만들고
            let numbers = [decodeData.drwtNo1, decodeData.drwtNo2, decodeData.drwtNo3, decodeData.drwtNo4, decodeData.drwtNo5, decodeData.drwtNo6]
            
            // (사용자 정의 구조체)로또 구조체에 디코딩된 데이터를 넣어준다.
            let lottoData = LottoInfo(drawData: decodeData.drwNoDate, firstMoney: decodeData.firstWinamnt, firstTicketsCount: decodeData.firstPrzwnerCo, numbers: numbers, bnusNum: decodeData.bnusNo)
            
            return lottoData // 생성된 LottoInfo 구조체 리턴
            
        } catch { // 에러 발생시
            print("JSON decoding error: \(error)") // 에러를 자세히 로깅
            //print(error.localizedDescription)
            return nil
        }
    }
}

extension NetworkManager {
    // 🔶 테이블뷰 셀 개수를 어떻게 리턴시킬까?
    func getCount() -> Int {
        return 5
    }
    
}
