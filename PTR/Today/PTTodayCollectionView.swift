//
//  PTTodayCollectionView.swift
//  PTR
//
//  Created by Hussein Al-Ryalat on 9/30/18.
//  Copyright © 2018 SketchMe. All rights reserved.
//

import UIKit

class PTTodayCollectionView: UICollectionView {
    
    let heightMultiplier: CGFloat = 1.2
    
    var itemsCountPerRow: Int {
        let isLandscape = UIDevice.current.orientation.isLandscape
        let isRegularWidth = UIScreen.main.traitCollection.horizontalSizeClass == .regular
        return (isLandscape || isRegularWidth) ? 3 : 2
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup(){
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.scrollDirection = .vertical
        layout.itemSize = calculateItemSize()
        
        self.ds_register(cellNib: PTCollectionCardCollectionViewCell.self)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = calculateItemSize()
    }
    
    private func calculateItemSize() -> CGSize {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let width = bounds.width
        let paddings = ((layout.sectionInset.right + layout.sectionInset.left) + (layout.minimumInteritemSpacing * CGFloat(itemsCountPerRow)))
        let itemWidth = (width - paddings) / CGFloat(itemsCountPerRow)
        return CGSize(width: itemWidth, height: itemWidth * heightMultiplier)
    }
}
