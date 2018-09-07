//
//  ViewController.swift
//  SKU解决方案
//
//  Created by ayibang on 2018/8/28.
//  Copyright © 2018年 Huang. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        makeConstraints()
    }
    
    // MARK: - 事件响应
    
    // MARK: - 私有方法
    func loadData() {
        let url = "https://jsonblob.com/api/jsonBlob/72ab3568-aa92-11e8-9316-b586f5edc649"
        Alamofire.request(url).response { (response) in
            
            if let json = try? JSON(data: response.data!){
                
                var specDatas = [Model.spec]()
                let lists: Array<JSON> = json["spec"].arrayValue
                for list in lists {
                    if let name: String = list["name"].string{
                        let values: Array<JSON> = list["value"].arrayValue
                        var valBool: Array<SelectStates> = [SelectStates]()
                        var vas = [String]()
                        for va in values {
                            if let val = va.string {
                                vas.append(val)
                                valBool.append(SelectStates.noSelectStates)
                            }
                        }
                        let mode = Model.spec.init(name: name, value: vas,values: valBool)
                        specDatas.append(mode)
                    }
                }
                
                var skuDatas = [Model.sku]()
                let skuLists: Array<JSON> = json["sku"].arrayValue
                for skulist in skuLists {
                    let skuCondition: Array<JSON> = skulist["condition"].arrayValue
                    var skuCondi = [String]()
                    for skucon in skuCondition{
                        if let sku = skucon.string{
                            skuCondi.append(sku)
                        }
                    }
                    let mode = Model.sku.init(condition: skuCondi)
                    skuDatas.append(mode)
                }
                self.dataSource = Model(sepcData: specDatas, skuData: skuDatas)
                
                // 数据转换 关键点
                self.dataSource = ModelManager.checkData(dataSource: self.dataSource!)
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    // MARK: - 基本属性
    var collectionView: UICollectionView?
    var dataSource: Model?
    // MARK: - 约束
    func makeConstraints(){
        self.collectionView = {
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 100, height: 50)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsetsMake(8, 16, 8, 16)
            
            let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
            
            collectionView.backgroundColor = UIColor.white
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: CollectionViewCell.CellIdentifier())
            collectionView.register(HeadCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeadCollectionReusableView.CellIdentifier())
            
            self.view.addSubview(collectionView)
            
            collectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.view.snp.bottom)
            })
            return collectionView
        }()
    }
}


// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section) + \(indexPath.row)")
        
        if let model = ModelManager.selectorCellDealData(dataSource: self.dataSource!, indexPath: indexPath) {
            // 4. 处理数据
            self.dataSource = model
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeadCollectionReusableView.CellIdentifier(), for: indexPath) as? HeadCollectionReusableView
            headView?.label?.text = self.dataSource?.specData[indexPath.section].name
            return headView ?? HeadCollectionReusableView()
        case UICollectionElementKindSectionFooter:
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.specData.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.specData[section].value.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: CollectionViewCell.CellIdentifier(), for: indexPath) as? CollectionViewCell
        if let value: String = self.dataSource?.specData[indexPath.section].value[indexPath.row],
            let values: SelectStates = self.dataSource?.specData[indexPath.section].values[indexPath.row]
        {
            cell?.label?.text = "\(value)"
            cell?.values = values
        }
        return cell ?? CollectionViewCell()
    }
    
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 375, height: 50)
    }
}
