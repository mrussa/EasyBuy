//
//  Product.swift
//  EasyBuy
//
//  Created by  on 2/11/25.
//

import Foundation

struct Product: Decodable {
    var id: Int
    var title: String
    var price: Int
    var description: String
    var images: [String]
    
    struct Category: Decodable {
        var id: Int
        var name: String
        var image: String
    }
}

