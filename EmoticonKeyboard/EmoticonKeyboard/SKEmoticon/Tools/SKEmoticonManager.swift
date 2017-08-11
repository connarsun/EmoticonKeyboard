//
//  SKEmoticonManager.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/7/27.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

class SKEmoticonManager {
    static let shared = SKEmoticonManager()
    private init() {
        loadPackages()
    }
    
    lazy var packages = [SKEmoticonPackage]()
    
    lazy var bundle: Bundle = {
        guard let bundlePath = Bundle.main.path(forResource: "SKEmoticon", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle()
        }
        return bundle
    }()
}

extension SKEmoticonManager {
    fileprivate func loadPackages() {
        guard let bundlePath = Bundle.main.path(forResource: "SKEmoticon", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath),
            let plistPath = bundle.path(forResource: "emoticons", ofType: ".plist"),
            let packageArr = NSArray(contentsOfFile: plistPath) as? [[String: String]]
            else {
                return
        }
        for dict in packageArr {
            packages.append(SKEmoticonPackage(dict))
        }
    }
    
    fileprivate func matchEmoticon(str: String) -> SKEmoticonModel? {

        for package in packages {
            let results = package.emoticonModels.filter({$0.chs == str})
            if results.count == 1 {
                return results[0]
            }
        }
        
        return nil
    }
    
    func emoticonString(_ str: String, font: UIFont = UIFont.systemFont(ofSize: 15)) -> NSAttributedString {
        
        let attributeStr = NSMutableAttributedString(string: str)
        
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return attributeStr }
        let results = regex.matches(in: str, options: [], range: NSRange(location: 0, length: attributeStr.length))
        
        for r in results.reversed() {
            let subStr = (attributeStr.string as NSString).substring(with: r.range)
            let model = matchEmoticon(str: subStr)
            if let attribute = model?.imageText(font: font) {
                attributeStr.replaceCharacters(in: r.range, with: attribute)
            }
        }
        
        return attributeStr
    }
}
