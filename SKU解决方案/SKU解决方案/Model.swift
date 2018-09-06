//
//  Model.swift
//  SKU解决方案
//
//  Created by ayibang on 2018/9/3.
//  Copyright © 2018年 Huang. All rights reserved.
//

import UIKit

enum SelectStates {
    case noSelectStates                     // 不可选中
    case canSelectStates                    // 可以选择
    case seleSelectStates                   // 已经选中
}

class Model: NSObject {
    
    struct spec {
        var name: String
        var value: [String]
        var values: [SelectStates]             // 用来记录对应的 value 是否可以选择. 处理完数据用来存储
    }
    var specData: [spec]
    
    struct sku {
        var condition: [String]
    }
    var skuData: [sku]
            
    init?(sepcData: [spec],skuData: [sku]){
        self.specData = sepcData
        self.skuData = skuData
        self.selectArr = Array(repeating:"", count: specData.count)
        self.selectArrChai = [[String]]()
    }
    
    // 选中集合
    var selectArr: [String]!            // 选中的集合
    var selectArrChai: [[String]]!      // 根据选中的集合拆开的内容
    
}
