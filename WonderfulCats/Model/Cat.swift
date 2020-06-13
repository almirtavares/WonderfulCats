//
//  Cat.swift
//  WonderfulCats
//
//  Created by Almir Tavares on 11/06/20.
//  Copyright © 2020 DevVenture. All rights reserved.
//

import Foundation


class Cats : Codable {
    
    let data: [Cat]
    
    init(cats: Cats) {
        self.data = cats.data
    }
}

class Cat : Codable {
    
    var id: String
    var title: String
    var link: String
    var images: [Images]?
}

class Images : Codable {
    
    let id: String
    let width: Int
    let height: Int
    let type: String
    let link: String
}
