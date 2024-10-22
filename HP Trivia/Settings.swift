//
//  Settings.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-07.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var store: Store
    
    var body: some View {
        ZStack {
            infoBackgroundImage()
            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(0..<7) { i in
                            if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIds.contains("hp\(i+1)")){
                                    ZStack(alignment: .bottomTrailing) {
                                        Image("hp\(i+1)")
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(radius: 7)
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.largeTitle)
                                            .imageScale(.large)
                                            .foregroundStyle(.green)
                                            .shadow(radius: 1)
                                            .padding(3)
                                    }
                                    .task {
                                        store.books[i] = .active
                                        store.saveStatus()
                                    }
                                    .onTapGesture {
                                        store.books[i] = .inactive
                                        store.saveStatus()
                                    }
                            } else if store.books[i] == .inactive {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image("hp\(i+1)")
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(radius: 7)
                                            .overlay(Rectangle().opacity(0.33))
                                        
                                        Image(systemName: "circle")
                                            .font(.largeTitle)
                                            .imageScale(.large)
                                            .foregroundStyle(.green.opacity(0.5))
                                            .shadow(radius: 1)
                                            .padding(3)
                                    }
                                    .onTapGesture {
                                        store.books[i] = .active
                                        store.saveStatus()
                                    }
                                } else {
                                    ZStack() {
                                        Image("hp\(i+1)")
                                            .resizable()
                                            .scaledToFit()
                                            .shadow(radius: 7)
                                            .overlay(Rectangle().opacity(0.75))
                                        
                                        Image(systemName: "lock.fill")
                                            .font(.largeTitle)
                                            .imageScale(.large)
                                            .shadow(color: .white.opacity(0.75), radius: 3)
                                            .padding(3)
                                    }
                                    .onTapGesture {
                                        let productID = "hp\(i + 1)"
                                            //looking for first element who can fit
                                        if let product = store.products.first(where: { $0.id == productID }) {
                                            
                                            Task {
                                                await store.purchase(product)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                }
                
                Button("Done") {
                    dismiss()
                }
                .doneButton()
            }
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    Settings()
        .environmentObject(Store())
}
