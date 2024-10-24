//
//  Store.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-19.
//

import Foundation
import StoreKit

enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .inactive, .active, .locked, .locked, .locked, .locked]
    
    @Published var products: [Product] = []
    @Published var purchasedIds = Set<String>()
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldn't fetch those products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
                //purchase was successful, but now we have to verify receipt
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on: \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    purchasedIds.insert(signedType.productID)
                }
                
                // User cancelled or parent disapprovesd purchase
            case .userCancelled:
                break
                
                //waiting for the approval
            case .pending:
                break
                
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase this product: \(error)")
        }
    }
    
    func saveStatus() {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    func loadStatus() {
        do {
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch {
            print("Couldn't load book statuses: \(error)")
        }
    }
    
    private func checkPurchase() async {
        for product in products {
            //looking for the states: success, pending, userCancelled
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on: \(signedType): \(verificationError)")
            case .verified(let signedType):
                
                if signedType.revocationDate == nil {
                    purchasedIds.insert(signedType.productID)
                } else {
                    purchasedIds.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchase()
            }
        }
    }
}
