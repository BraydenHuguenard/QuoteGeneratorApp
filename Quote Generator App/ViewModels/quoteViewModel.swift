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
                    self.quote = QuoteGenerator(quote: firstQuote, artist: author)
                    self.quoteHistory.append(self.quote)
                }
            } else {
                DispatchQueue.main.async {
                    self.currentQuote = "Failed to fetch quote. Try again."
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
        
    func getQuoteByImage() {
        fetchQuote(from: "https://zenquotes.io/api/image/")
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

