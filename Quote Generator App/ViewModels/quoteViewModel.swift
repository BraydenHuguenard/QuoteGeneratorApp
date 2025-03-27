//
//  QuoteViewModel.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//

import Foundation

struct QuoteGenerator: Identifiable {
    var id = UUID()
    var quote: String
    var artist: String
    var image: String?
    
    // Initializer to create a Quote
    init(quote: String, artist: String, image: String? = nil) {
        self.quote = quote
        self.artist = artist
        self.image = image
    }
}
