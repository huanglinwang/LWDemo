//
//  CollectionViewCell.swift
//  SKU解决方案
//
//  Created by ayibang on 2018/9/3.
//  Copyright © 2018年 Huang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.brown
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 私有方法
    class func CellIdentifier () -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    // MARK: - 基本属性
    var label: UILabel?
    var values: SelectStates? {
        willSet(newValue){
            
            switch newValue! {
            case SelectStates.canSelectStates:
                self.contentView.backgroundColor = UIColor.red
            case SelectStates.noSelectStates:
                self.contentView.backgroundColor = UIColor.lightGray
            case SelectStates.seleSelectStates:
                self.contentView.backgroundColor = UIColor.blue
            }
        }
    }
    // MARK: - 约束
    func makeConstraints(){
        self.label = {
            let lab = UILabel()
            lab.font = UIFont.systemFont(ofSize: 16)
            lab.textColor = UIColor.black
            
            self.contentView.addSubview(lab)
            
            lab.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.contentView)
                make.centerY.equalTo(self.contentView)
            })
            return lab
        }()
    }
}
