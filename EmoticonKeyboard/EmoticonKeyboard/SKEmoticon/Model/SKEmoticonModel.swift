//
//  SKEmoticonModel.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/8/1.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

class SKEmoticonModel: NSObject {
    /// 表情字符串--简体中文
    var chs = "" // e.g. [偷乐]
    /// 表情字符串--繁体中文
    var cht = "" // e.g. [偷樂]
    /// gif图片
    var gif = "" // e.g. lxh_toule.gif
    /// 表情图片名称，用于图文混排
    var png = "" // e.g. lxh_toule.png
    /// 表情类型 0(图片表情) / 1(emoji表情)
    var type = "" // e.g. 0(图片表情) / 1(emoji表情)
    /// emoji表情 16进制编码
    var code: String? {
        didSet {
            guard let code = code else { return }
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            guard let scalar = UnicodeScalar(result) else { return }
            emoji = String(Character(scalar))
        }
    } // e.g. 0x1f61e emoji 16进制编码
    /// emoji的字符串
    var emoji = ""
    /// 表情图片所在目录
    var directory = ""
    /// 表情图片对应的图片
    var image: UIImage? {
        if type == "1" { return nil }
        guard let path = Bundle.main.path(forResource: "SKEmoticon", ofType: "bundle"),
            let bundle = Bundle(path:path)  else { return nil }
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 是否是删除按钮
    var isRemove = false
    convenience init(isRemove: Bool) {
        self.init()
        self.isRemove = isRemove
    }
    
    /// 是否是空白表情
    var isEmpty = false
    convenience init(isEmpty: Bool) {
        self.init()
        self.isEmpty = isEmpty
    }
    
    convenience init(_ dict: [String: Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

extension SKEmoticonModel {
    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrStrM.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: 1))
        
        return attrStrM
    }
}

class SKEmoticonPackage: NSObject {
    /// 表情包名称
    var groupName = ""
    /// 表情包目录，从该目录下加载info.plist
    var directory: String? {
        didSet {
            guard let directory = directory,
                let bundlePath = Bundle.main.path(forResource: "SKEmoticon", ofType: "bundle"),
                let bundle = Bundle(path: bundlePath),
                let emoticonPath = bundle.path(forResource: "info", ofType: "plist", inDirectory: directory),
                let emoticonArr = NSArray(contentsOfFile: emoticonPath) as? [[String: String]]
                else { return }
            var index: Int = 0
            for dict in emoticonArr {
                index += 1
                emoticonModels.append(SKEmoticonModel(dict))
                if index == 20 {
                    index = 0
                    emoticonModels.append(SKEmoticonModel(isRemove: true))
                }
            }
            
            let count = emoticonModels.count % 21
            if count != 0 {
                for _ in count ..< 20 {
                    emoticonModels.append(SKEmoticonModel(isEmpty: true))
                }
                emoticonModels.append(SKEmoticonModel(isRemove: true))
            }

            for model in emoticonModels {
                model.directory = directory
            }
        }
    }
    /// 背景图片名称
    var bgImageName = ""
    
    /// 表情包模型数组
    lazy var emoticonModels = [SKEmoticonModel]()
    
    convenience init(_ dict: [String: Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
