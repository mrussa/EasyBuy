//
//  Product.swift
//  EasyBuy
//
//  Created by  on 2/11/25.
//

import Foundation

// MARK: - Product
struct Product: Hashable, Codable {
    
    var id: Int
    var title: String
    var price: Int
    var description: String
    var images: [String]
    
    var category: Category 
    
    struct Category: Hashable, Codable {
        var id: Int
        var name: String
        var image: String
    }
}

