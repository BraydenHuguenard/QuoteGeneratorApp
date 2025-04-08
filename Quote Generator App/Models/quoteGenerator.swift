//
//  quoteGenerator.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 4/1/25.
//

import Foundation

struct QuoteGenerator: Identifiable {
    var id = UUID()
    var quote: String?
    var artist: String?
    var image: String?
    var imageData: Data?
    
    // Initializer to create a Quote
    init(quote: String? = nil, artist: String? = nil, image: String? = nil, imageData: Data? = nil) {
        self.quote = quote
        self.artist = artist
        self.image = image
        self.imageData = imageData
    }
}
