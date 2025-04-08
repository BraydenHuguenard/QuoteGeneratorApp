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
    var dateSaved: String
    
    // Initializer to create a Quote
    init(quote: String? = nil, artist: String? = nil, image: String? = nil, imageData: Data? = nil) {
        self.quote = quote
        self.artist = artist
        self.image = image
        self.imageData = imageData
        self.dateSaved = "April 9, 2025"
    }
    mutating func setdateSaved() {
        self.dateSaved = getFormattedDate( )
    }
    func getFormattedDate()-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
}
