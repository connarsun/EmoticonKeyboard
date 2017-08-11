//
//  ViewController.swift
//  EmoticonKeyboard
//
//  Created by sun on 2017/8/11.
//  Copyright © 2017年 sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var contentLabel: UILabel!
    
    var inputViewTF: SKInputView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputViewTF = SKInputView(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        inputViewTF?.backgroundColor = UIColor.green
        inputViewTF?.delegate = self
        view.addSubview(inputViewTF!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputViewTF?.textView?.resignFirstResponder()
    }
}


extension ViewController: SKInputViewDelegate {
    func inputView(_ inputView: SKInputView, sendText text: String) {
        
        contentLabel.attributedText = SKEmoticonManager.shared.emoticonString(text)
        
        
        print("text:\(text):")
    }
}
