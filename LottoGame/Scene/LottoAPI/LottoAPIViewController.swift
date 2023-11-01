//
//  LottoAPIViewController.swift
//  LottoGame
//
//  Created by 유성열 on 11/1/23.
//

import UIKit

// 로또 API 네트워크 매니저와 통신하는 뷰컨
class LottoAPIViewController: UIViewController {
    
    let drawDateLabel: UILabel = {
        let label = UILabel()
        label.text = "발표날짜"
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
