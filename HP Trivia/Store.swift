//
//  Store.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-19.
//

import Foundation
import StoreKit

enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .inactive, .active, .inactive, .locked, .locked, .locked]
    
    @Published var products: [Product] = []
    
    private var productIDs = ["hp5", "hp6", "hp7"]
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldn't fetch those products: \(error)")
        }
    }
}
