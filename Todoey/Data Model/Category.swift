//
//  Category.swift
//  Todoey
//
//  Created by Baran Atmanoglu on 2/13/18.
//  Copyright © 2018 Baran Atmanoglu. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var backgroundcolor : String = UIColor.black.hexValue()
    let items = List<Item>()
    
}
//Buradaki Object Realm object..
