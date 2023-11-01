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
    let num1, num2, num3, num4, num5, num6: Int // 1~6 번호
    let bnusNum: Int // 보너스 번호
}

// 네트워크 매니저
struct NetworkManager {
    
    
    
}
