//
//  SKToolBarView.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/8/8.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

class SKToolBarView: UIView {

    fileprivate var sendBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension SKToolBarView {
    func setupUI() {
        sendBtn = UIButton(type: .custom)
        sendBtn.frame = CGRect(x: 0, y: 0, width: 100, height: bounds.height)
        
    }
}
