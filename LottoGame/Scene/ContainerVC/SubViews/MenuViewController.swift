//
//  MenuViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/11/23.
//

import UIKit

// 프로토콜 구현(통신을 위한 델리게이트)
// 메뉴안에 정렬된 메뉴들을 눌렀을때 전달을 위한 프로토콜
// 메인뷰컨트롤러와 연결
protocol MenuViewControllerDelegate: AnyObject { // AnyObject는 모든 클래스타입
    func didSelect(menuItem: MenuViewController.MenuOptions)
}


// 메뉴 뷰컨트롤러
final class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: MenuViewControllerDelegate? // 대리자 지정 델리게이트 변수(약한 참조로)
    
    // 메뉴에 표시할 열거형(CaseIterable 채택 -> allCases 사용 가능해짐(모든 케이스를 나열한 배열을 리턴))
    enum MenuOptions: String, CaseIterable {
        case home = "메인 화면"
        case info = "회차별 당첨 정보"
        case qrCode = "QR Code"
//        case map = "판매점 찾기" // 보류
        
    // 열거형 내부에 get 계산속성 구현(해당하는 case에 이미지 이름을 리턴해서 SF 기호 이름을 리턴시킴)
    // 계산속성은 실질적으로 메서드이다! 잊지말자
        var imageName: String {
            switch self { // 여기서 self는 열거형?
            case .home:
                return "house"
            case .info:
                return "info.bubble"
            case .qrCode:
                return "qrcode"
//            case .map:
//                return "map" // 보류
            }
        }
    }
    
    // 기본 테이블뷰를 만듦
    private let tableView: UITableView = {
       let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // 셀을 직접 만들지 않고 기본 제공되는 UITableViewCell
        return table
    }()
    
    // 뷰와 테이블뷰셀 색상을 동일하게 변수로 색상 설정
    //let grayColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    // 🔶컬러 꼭 /255.0 을 해주는게 맞는건가?
    let cerBlueColor = UIColor(red: 0.25, green: 0.47, blue: 0.60, alpha: 1.00)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        view.backgroundColor = cerBlueColor
    }
    
    // 뷰컨트롤러 생명주기
    // 테이블뷰 프레임 설정(뷰컨트롤러와 관련된 뷰의 레이아웃이 업데이트 된 후 호출)(뷰의 레이아웃이 업데이트된 직후에 호출되므로 뷰의 크기, 위치, 계층 구조가 최종적으로 설정된 후에 실행)(뷰의 최종 레이아웃을 기반으로 사용자 정의 레이아웃)
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count // 모든 메뉴 만큼
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue // 모든메뉴 기준으로 rawValue(원시값)를 가져옴
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName) // UIImage로 설정하는데 메뉴 열거형에서 올케이스에서 계산속성을 사용해서 인덱스 기준 이미지 네임 스위칭해서 래핑(SF기호)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = cerBlueColor // 테이블뷰 셀 백그라운드 설정
        cell.contentView.backgroundColor = cerBlueColor // 셀 내용 뷰의 배경색을 설정)
        cell.selectionStyle = .gray
        
        return cell
    }
    
    // 선택적 메서드(UITableViewDelegate)
    // 사용자가 테이블뷰의 특정 행을 선택할때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 선택시 배경색 변경
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.contentView.backgroundColor = UIColor.systemBlue
//        }
        
        tableView.deselectRow(at: indexPath, animated: true) // 선택한 행의 선택 상태를 해제(선택 취소)(선택했을때 해당 행이 선택된 상태로 남아있지 않도록)
        
        let item = MenuOptions.allCases[indexPath.row] // 선택된 메뉴를 뽑아서 아이템에 넣고
        delegate?.didSelect(menuItem: item) // 델리게이트 메서드에 전달(델리게이트 대리자만 함수 호출이 가능)(특정 셀이 선택되었을때)
    }
    
    // 사용자가 테이블뷰의 특정 행을 선택해제 할때 호출되는 메서드
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 셀 선택 해제시 원래 배경색 변경
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.contentView.backgroundColor = UIColor.clear
//        }

    }

}
