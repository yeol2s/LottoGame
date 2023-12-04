//
//  NumberBallCreateManager.swift
//  LottoGame
//
//  Created by 유성열 on 12/3/23.
//

import UIKit

// 공 번호로 표시해주는 클래스
// UIStackView로 만듦
final class NumberBallListView: UIStackView {
    
    func displayNumbers(_ numbers: [Int]) {
        // 기존 하위뷰 제거?
        // 디스플레이 콘텐츠에 대한 뷰를 준비하기 위한 깨끗한 상태를 보장하는 일반적인 방법?
        // removewFromSuperView() - 해당 뷰가 현재 부모 뷰에서 제거되며 뷰 계층 구조에서 제거됨
        // 메모리에서 제거되는 작업은 아님(다른 객체가 뷰에 대한 강한 참조를 가지고 있지 않다면 해당 뷰는 메모리에서 해제되긴 함 - 한마디로 nil)
        // forEach 고차함수 -> 각각을 가지고 일을하고 끝냄(배열리턴 x - 리턴타입 없음)
        // 한마디로 새로운 공 모양의 숫자를 표시하기 전에, 기존의 숫자를 모두 지워 새로운 숫자를 표시
        self.subviews.forEach { $0.removeFromSuperview() }
        
        let ballDiameter: CGFloat = 40 // 공의 지름
        let ballRadius: CGFloat = ballDiameter / 2 // 공의 반지름
        
        var arrangedSubViews: [UIView] = []
        
        // 파라미터로 받은 숫자 배열을 반복시켜서 각 숫자에 대한 공 모양 UILabel을 생성
        for number in numbers {
            let ball = UILabel()
            ball.text = "\(number)"
            ball.textAlignment = .center
            ball.layer.cornerRadius = ballRadius // 원 모양으로 깎아줌
            ball.layer.masksToBounds = true // 경계를 벗어나는 부분 잘라내기
            ball.font = UIFont.boldSystemFont(ofSize: 16)
            ball.textColor = .white
            ball.widthAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            ball.heightAnchor.constraint(equalToConstant: ballDiameter).isActive = true
            
            // 번호 단위별 공의 색상 설정
            switch number {
            case 1...9:
                ball.backgroundColor = UIColor.systemPink
            case 10...19:
                ball.backgroundColor = UIColor.systemOrange
            case 20...29:
                ball.backgroundColor = UIColor.systemBrown
            case 30...39:
                ball.backgroundColor = UIColor.systemIndigo
            case 40...45:
                ball.backgroundColor = UIColor.systemGreen
            default:
                ball.backgroundColor = UIColor.white
            }
            arrangedSubViews.append(ball) // [UIView]에 공 모양 하나씩 추가(반복문으로)
        }
        self.spacing = 10 // 각 공 사이 간격 조절
        arrangedSubViews.forEach { self.addArrangedSubview($0) // 스택뷰에 UIView 하나씩 추가
        }
    }
}


