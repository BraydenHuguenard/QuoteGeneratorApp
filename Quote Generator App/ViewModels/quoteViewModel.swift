//
//  QuoteViewModel.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//

import Foundation

class QuoteViewModel: ObservableObject {
    @Published var quote: QuoteGenerator
    @Published var currentQuote: String = ""
    @Published var savedQuotes: [QuoteGenerator] = []
    @Published var savedImages: [QuoteGenerator] = []
    @Published var quoteHistory: [QuoteGenerator] = []
    
    init(quote: QuoteGenerator) {
        self.quote = quote
    }
    
    func fetchQuote(from urlString: String) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.currentQuote = "Invalid URL. Please try again."
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONSerialization.jsonObject(with: data) as? [[String: String]],
               let firstQuote = result.first? ["q"],
               let author = result.first? ["a"] {
                DispatchQueue.main.async {
                    self.currentQuote = firstQuote
                    self.quote = QuoteGenerator(quote: firstQuote)
                    self.quoteHistory.append(self.quote)
                }
            } else {
                DispatchQueue.main.async {
                    self.currentQuote = "Failed to fetch quote. Try again."
                }
            }
        }.resume()
    }
    
    func getQuoteByImage() {
        guard let url = URL(string: "https://zenquotes.io/api/image/") else {
            DispatchQueue.main.async {
                self.currentQuote = "Invalid URL."
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.quote = QuoteGenerator(quote: nil, imageData: data)
                    self.currentQuote = ""
                    self.quoteHistory.append(self.quote)
                    print("Image quote set!")
                }
            } else {
                DispatchQueue.main.async {
                    self.currentQuote = "Failed to load image quote."
                    print("Image quote failed.")
                }
            }
        }.resume()
    }
    
    func getQuoteRandom() {
        fetchQuote(from: "https://zenquotes.io/api/random/")
    }
        
    func getQuoteByArtist(authorName: String) {
        let formattedAuthorName = authorName.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
        
        guard !formattedAuthorName.isEmpty else {
            quote = QuoteGenerator(quote: "Please enter an author's name.")
            return
        }
        
        fetchQuote(from: "https://zenquotes.io/api/quotes/author/\(formattedAuthorName)/")
    }
        
    func getDailyQuote() {
        fetchQuote(from: "https://zenquotes.io/api/today/")
    }
    
    func saveQuote() {
        if !savedQuotes.contains(where: { $0.quote == quote.quote }) {
            quote.setdateSaved()
            savedQuotes.append(quote)
        }
    }
}

