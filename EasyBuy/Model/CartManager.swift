//
//  CartManager.swift
//  EasyBuy
//
//  Created by mruss on 2/15/25.
//

import Foundation

// MARK: - CartItem
struct CartItem: Codable, Equatable {
    let product: Product
    var quantity: Int
}

// MARK: - CartManager
class CartManager {
    static let shared = CartManager()
    
    private let key = "cartItems"
    private(set) var items: [CartItem] = []
    
    private init() {
        load()
    }
    
    // MARK: - Cart Management Methods
    func add(product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            items.append(newItem)
        }
        save()
    }
    
    func remove(product: Product) {
        items.removeAll { $0.product.id == product.id }
        save()
    }
    
    func clear() {
        items.removeAll()
        save()
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity = quantity
        }
        save()
    }
    
    // MARK: - Persistence
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedItems = try? JSONDecoder().decode([CartItem].self, from: data)
        else {
            return
        }
        items = savedItems
    }
}
