//
//  SKInputView.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/7/12.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

protocol SKInputViewDelegate: class, NSObjectProtocol {
    func inputView(_ inputView: SKInputView, sendText text: String)
}

class SKInputView: UIView {
    
    var maxLine: Int = 3
    var textView: UITextView!
    weak var delegate: SKInputViewDelegate?
    
    fileprivate var keyBoardH: CGFloat = 0.0
    fileprivate var keyBoardDuration = 0.0
    fileprivate var keyBoardPreH: CGFloat = 0.0
    
    fileprivate var textViewX: CGFloat = 5
    fileprivate var textViewY: CGFloat = 8.0
    
    
    fileprivate lazy var emoticonView: SKEmoticonView = {
        var titles = [String]()
        for model in SKEmoticonManager.shared.packages {
            titles.append(model.groupName)
        }
        
        let emoticonView = SKEmoticonView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), titles: titles)
        emoticonView.delegate = self
        return emoticonView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addListener()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

fileprivate extension SKInputView {
    func setupUI() {   
        let x = textViewX
        let y = textViewY
        let h = bounds.height - textViewY * 2
        let w = bounds.width - x * 2 - h - x
        let tfFrame = CGRect(x: x, y: y, width: w, height: h)
        
        textView = UITextView(frame: tfFrame)
        textView.delegate = self
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.returnKeyType = .send
        addSubview(textView!)
        
        let emoticonBtn = UIButton(frame: CGRect(x: tfFrame.width + x * 2,
                                                 y: textViewY,
                                                 width: tfFrame.height,
                                                 height: tfFrame.height))
        emoticonBtn.setImage(UIImage(named: "ToolViewEmotion"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "ToolViewKeyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        addSubview(emoticonBtn)
    }
    
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
}

fileprivate extension SKInputView {
    
    @objc func keyboardWillShow(_ noti: Notification) {
        keyBoardDuration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let rect = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        keyBoardH = rect.size.height
        
        var aFrame = self.frame
        aFrame.origin.y = rect.origin.y - frame.height
        UIView.animate(withDuration: keyBoardDuration) {
            self.frame = aFrame
        }
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        var aFrame = self.frame
        aFrame.origin.y += keyBoardH
        UIView.animate(withDuration: keyBoardDuration) {
            self.frame = aFrame
        }
    }
    
    @objc func emoticonBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        textView.reloadInputViews()
        
        textView.becomeFirstResponder()
    }
}

extension SKInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var currentH = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT))).height
        
        textView.isScrollEnabled = false
        let maxH = CGFloat(maxLine - 1) * (ceil(textView.font!.lineHeight) + textView.textContainerInset.top + textView.textContainerInset.bottom)
        if currentH >= maxH {
            textView.isScrollEnabled = true
            currentH = maxH
        }

        let y = UIScreen.main.bounds.height - currentH - keyBoardH - textViewY * 2.0
        let h = self.frame.height - self.textView!.bounds.height + currentH
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: y,
                                width: self.frame.width,
                                height: h)
            self.textView.frame = CGRect(x: self.textView!.frame.origin.x,
                                          y: self.textView!.frame.origin.y,
                                          width: self.textView!.frame.width,
                                          height: currentH)
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.inputView(self, sendText: textView.text)
            textView.text = ""
            return false
        }
        return true
    }
    
}

extension SKInputView: SKEmoticonViewDelegate {
    func emoticonView(_ emoticonView: SKEmoticonView, didSelectEmotion emoticon: SKEmoticonModel) {
        if emoticon.chs.characters.count == 0 {
            print("删除")
            textView.deleteBackward()
            return
        }
        print(emoticon.chs)
        guard let range = textView.selectedTextRange else { return }
        textView.replace(range, withText: emoticon.chs)
    }
    
    func emoticonView(_ emoticonView: SKEmoticonView, didClicktSendBtn sender: UIButton) {
        delegate?.inputView(self, sendText: textView.text)
        textView.text = ""
    }
}
