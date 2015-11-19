//
//  JFGoodModel.swift
//  shoppingCart
//
//  Created by Solo on 15/11/17.
//  Copyright © 2015年 Solo. All rights reserved.
//

import UIKit

class JFGoodModel: NSObject
{
    var alreadyAddShoppingCart: Bool = false
    var iconName: String?
    var title: String?
    var desc: String?
    var count: Int = 1
    var newPrice: String?
    var oldPrice: String?
    var selected: Bool = true
    
    init(dict: [String : AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    /**
     *防止对象属性和kvc时的dict的key不匹配而崩溃
     */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
}
