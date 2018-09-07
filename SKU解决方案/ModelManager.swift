//
//  ModelManager.swift
//  SKU解决方案
//
//  Created by ayibang on 2018/9/3.
//  Copyright © 2018年 Huang. All rights reserved.
//

import UIKit

class ModelManager: NSObject {
    
    // *** 初始化的过滤操作  核心方法,转化数据
    class func checkData(dataSource: Model) -> Model {
        
        // 初始化
        dataSource.selectArrChai.removeAll()
        
        // 第一步拆 根据选中集合 -> 获取到筛选的条件
        for index in dataSource.selectArr.startIndex ..< dataSource.selectArr.endIndex{
            var temp = dataSource.selectArr
            temp!.remove(at: index)
            dataSource.selectArrChai.append(temp!)
        }
        
        // 第二步 通过条件进行筛选 -> 遍历sku集合
        
        for seleIndex in  dataSource.specData.startIndex ..<  dataSource.specData.endIndex{ // 行数
            
            // 初始化属性的状态. 之前选中的还是选中,否则就是不可选.
            for  indexA in dataSource.specData[seleIndex].values.startIndex ..< dataSource.specData[seleIndex].values.endIndex {
                if dataSource.specData[seleIndex].values[indexA] == SelectStates.seleSelectStates{
                    dataSource.specData[seleIndex].values[indexA] = SelectStates.seleSelectStates
                }else{
                    dataSource.specData[seleIndex].values[indexA] = SelectStates.noSelectStates
                }
            }
            
            // 过滤操作
            for index in dataSource.skuData.startIndex ..< dataSource.skuData.endIndex{ // sku 数量
                
                let aArr: [String] = dataSource.skuData[index].condition    // sku
                let bArr:[String] =  dataSource.selectArrChai[seleIndex]    // 条件
                
                if self.isSuperset(aArr: aArr, isSuperset: bArr) {          // 满足条件
                    print("\(dataSource.skuData[index].condition[seleIndex])")
                    
                    for ind in dataSource.specData[seleIndex].value.startIndex ..< dataSource.specData[seleIndex].value.endIndex{       // 找匹配的 sku属性的下标
                        if dataSource.skuData[index].condition[seleIndex] ==  dataSource.specData[seleIndex].value[ind]{       // 确定下标 ind
                            
                            if dataSource.specData[seleIndex].values[ind] != SelectStates.seleSelectStates {    // 如果不是选中的就让他可选.如果是选中的就什么也不做
                                dataSource.specData[seleIndex].values[ind] = SelectStates.canSelectStates
                            }
                        }
                    }
                }
            }
        }
        return dataSource
    }
    
    // 点击 cell 之后的过滤操作  根据 index 修改对应的属性状态
    class func selectorCellDealData(dataSource: Model, indexPath: IndexPath) -> Model? {
        
        // 1. 判断是否可以点击
        let bool: SelectStates = dataSource.specData[indexPath.section].values[indexPath.row]
        if bool == .noSelectStates {
            return nil
        }
        
        // 2. 当前组 变得都可选
        for ind in dataSource.specData[indexPath.section].values.startIndex ..< dataSource.specData[indexPath.section].values.endIndex{
            dataSource.specData[indexPath.section].values[ind] = .canSelectStates
        }
        
        // 3. 修改选中集合, 修改属性的枚举状态
        switch bool {
        case .canSelectStates:
            
            dataSource.selectArr[indexPath.section] = dataSource.specData[indexPath.section].value[indexPath.row]
            dataSource.specData[indexPath.section].values[indexPath.row] = .seleSelectStates
            
        case .seleSelectStates:
            dataSource.selectArr[indexPath.section] = ""
            dataSource.specData[indexPath.section].values[indexPath.row] = .canSelectStates
        case .noSelectStates:
            return dataSource
        }
        
        return self.checkData(dataSource: dataSource)
    }
    
    // 数组A 是否包涵数组 B 的所有元素
    class func isSuperset(aArr:[String],isSuperset bArr:[String]) -> Bool {
        var boo: Int = 0
        for b in bArr{
            if aArr.contains(b) || b == "" {
                boo += 1
            }
        }
        if boo == bArr.count {
            return true
        }
        return false
    }
}



