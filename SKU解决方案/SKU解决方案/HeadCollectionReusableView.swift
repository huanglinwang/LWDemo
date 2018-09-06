//
//  HeadCollectionReusableView.swift
//  SKU解决方案
//
//  Created by ayibang on 2018/9/3.
//  Copyright © 2018年 Huang. All rights reserved.
//

import UIKit

class HeadCollectionReusableView: UICollectionReusableView {
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
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
    
    // MARK: - 约束
    func makeConstraints(){
        let lab = UILabel()
        self.label = lab
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor.black
        
        self.addSubview(lab)
        
        lab.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(32)
        })
        
    }
}
