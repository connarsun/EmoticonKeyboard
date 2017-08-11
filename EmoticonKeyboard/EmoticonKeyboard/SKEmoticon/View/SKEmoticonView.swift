//
//  SKEmoticonCell.swift
//  SKTextFieldDemo
//
//  Created by john on 2017/8/1.
//  Copyright © 2017年 john. All rights reserved.
//

import UIKit

private let kSKEmoticonCell = "kSKEmoticonCell"

private let pageControlH: CGFloat = 20
private let titleViewH: CGFloat = 40
private let sendBtnW: CGFloat = 60

protocol SKEmoticonViewDelegate: class {
    func emoticonView(_ emoticonView: SKEmoticonView, didSelectEmotion emoticon: SKEmoticonModel)
    func emoticonView(_ emoticonView: SKEmoticonView, didClicktSendBtn sender: UIButton)
}

class SKEmoticonView: UICollectionViewCell {
    
    fileprivate var layout: SKEmoticonFlowLayout!
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var sourceIndexPath = IndexPath(item: 0, section: 0)
    fileprivate var titleView: SKTitleView!
    fileprivate var sendBtn: UIButton!
    
    weak var delegate: SKEmoticonViewDelegate?
    
    init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        setupUI(titles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKEmoticonView {
    func setupUI(_ titles: [String]) {
        
        layout = SKEmoticonFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let collectionViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - pageControlH - titleViewH)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(SKEmoticonCell.self, forCellWithReuseIdentifier: kSKEmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - pageControlH - titleViewH, width: frame.width, height: pageControlH))
        pageControl.backgroundColor = UIColor.red
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor.orange
        pageControl.isEnabled = false
        contentView.addSubview(pageControl)
        
        titleView = SKTitleView(frame: CGRect(x: 0, y: frame.height - titleViewH, width: frame.width - sendBtnW, height: titleViewH), titles: titles)
        titleView.isNeedScale = false
        titleView.delegate = self
        contentView.addSubview(titleView)
        
        sendBtn = UIButton(frame: CGRect(x: titleView.bounds.width, y: titleView.frame.origin.y, width: sendBtnW, height: titleView.bounds.height))
        sendBtn.backgroundColor = UIColor.yellow
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(UIColor.black, for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnAction(_:)), for: .touchUpInside)
        contentView.addSubview(sendBtn)        
    }
}

fileprivate extension SKEmoticonView {
    @objc func sendBtnAction(_ sender: UIButton) {
        delegate?.emoticonView(self, didClicktSendBtn: sender)
    }
}

extension SKEmoticonView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SKEmoticonManager.shared.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = SKEmoticonManager.shared.packages[section].emoticonModels.count
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.col * layout.row) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSKEmoticonCell, for: indexPath) as! SKEmoticonCell
        cell.emoticon = SKEmoticonManager.shared.packages[indexPath.section].emoticonModels[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = SKEmoticonManager.shared.packages[indexPath.section].emoticonModels[indexPath.item]
        delegate?.emoticonView(self, didSelectEmotion: emoticon)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewEndScroll()
    }
    
    fileprivate func scrollViewEndScroll() {
        // 取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 判断分组是否发生变化
        if sourceIndexPath.section != indexPath.section {
            let itemCount = SKEmoticonManager.shared.packages[indexPath.section].emoticonModels.count
            pageControl.numberOfPages = (itemCount - 1) / (layout.col * layout.row) + 1
            titleView.setTitle(1, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            sourceIndexPath = indexPath
        }
        
        pageControl.currentPage = indexPath.item / (layout.col * layout.row)
    }
    
}

extension SKEmoticonView: SKTitleViewDelegate {
    func titleView(_ titleView: SKTitleView, selectedIndex: Int) {
        let indexPath = IndexPath(item: 0, section: selectedIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
}

