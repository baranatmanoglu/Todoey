//
//  Item.swift
//  Todoey
//
//  Created by Baran Atmanoglu on 1/22/18.
//  Copyright © 2018 Baran Atmanoglu. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable{
    var title : String = ""
    var done : Bool = false
}


//Encodable Serializable gibi bisi/ encodable olmasi icin custom class olamaz.
