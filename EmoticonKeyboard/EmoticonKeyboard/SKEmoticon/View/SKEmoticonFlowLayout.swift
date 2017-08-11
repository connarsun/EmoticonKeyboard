//
//  SKEmoticonFlowLayout.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/8/2.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

class SKEmoticonFlowLayout: UICollectionViewFlowLayout {

    var col: Int = 7
    var row: Int = 3
 
    fileprivate lazy var cellAttrs = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWith: CGFloat = 0
}

extension SKEmoticonFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(col - 1)) / CGFloat(col)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(row - 1)) / CGFloat(row)
        
        let sectionCount = collectionView!.numberOfSections
        var prePageCount: Int = 0
        for i in 0 ..< sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0 ..< itemCount {
                let indexPath = IndexPath(item: j, section: i)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let page = j / (col * row)
                let index = j % (col * row)
                
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % col)
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / col)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                cellAttrs.append(attr)
            }
            prePageCount += (itemCount - 1) / (col * row) + 1
        }
        maxWith = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension SKEmoticonFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWith, height: 0)
    }
}
