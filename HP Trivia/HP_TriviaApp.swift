//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-03.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
