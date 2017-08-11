//
//  SKEmoticonSubCell.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/8/2.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

class SKEmoticonCell: UICollectionViewCell {
    
    /*
    fileprivate var emoticonBtn: UIButton!
    
    var emoticon: SKEmoticonModel? {
        didSet {
            if emoticon!.type == "1" {
                emoticonBtn.setImage(nil, for: .normal)
                emoticonBtn.setTitle(emoticon!.emoji, for: .normal)
            } else {
                emoticonBtn.setTitle(nil, for: .normal)
                emoticonBtn.setImage(emoticon!.image, for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        emoticonBtn = UIButton(type: .custom)
        emoticonBtn.adjustsImageWhenHighlighted = false
        emoticonBtn.frame = bounds
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_:)))
        emoticonBtn.addGestureRecognizer(longGes)
        addSubview(emoticonBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func longGesture(_ gesture: UIGestureRecognizer) {
        print("长按")
    }
    */
    
    fileprivate var imageView: UIImageView!
    
    var emoticon: SKEmoticonModel? {
        didSet {
            if emoticon!.isRemove {
                let image = UIImage(named: "compose_emotion_delete", in: SKEmoticonManager.shared.bundle, compatibleWith: nil)
                imageView.image = image
            } else {
                imageView.image = emoticon!.image
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(longGesture(_:)))
        imageView.addGestureRecognizer(longGes)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func longGesture(_ gesture: UIGestureRecognizer) {
        print("长按")
    }
}
