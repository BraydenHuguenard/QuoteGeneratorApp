//
//  Quote_Generator_AppApp.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//

import SwiftUI

@main
struct Quote_Generator_App: App {
    var body: some Scene {
        WindowGroup {
            HomePage(quoteVM: QuoteViewModel(quote: QuoteGenerator(quote: "Hello, World!", artist: "Author")))
        }
    }
}
