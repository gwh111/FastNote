//
//  ItemCollectionView.swift
//  FastWord
//
//  Created by gwh on 2020/8/9.
//  Copyright © 2020 gwh. All rights reserved.
//

import UIKit

class ItemCollectionView: UICollectionViewCell {
    
    @objc let textLabel = UILabel()
    @objc let stateBtn = UIButton()
    
    @objc var model:NoteModel! {
        willSet {
            
        }
        didSet {

            textLabel.text = model.summary
            textLabel.height = CGFloat(model.height-ccs.relativeHeight(25))
            
            stateBtn.top = textLabel.bottom
            stateBtn.right = textLabel.right
            stateBtn.backgroundColor = model.getColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        
        textLabel.frame = CGRect(x: CGFloat(ccs.relativeHeight(5)), y: CGFloat(ccs.relativeHeight(5)), width: self.frame.width-CGFloat(ccs.relativeHeight(10)), height: CGFloat(ccs.relativeHeight(20)))
        textLabel.font = ccs.relativeFont(16)
        textLabel.numberOfLines = 0
        self.contentView.addSubview(textLabel)
        
        stateBtn.size = CGSize(width: CGFloat(ccs.relativeHeight(20)), height: CGFloat(ccs.relativeHeight(15)))
//        stateBtn.setTitle("色块", for: .normal)
//        stateBtn.setTitleColor(UIColor.black, for: .normal)
        stateBtn.layer.cornerRadius = 4
        self.contentView.addSubview(stateBtn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
