//
//  HomePage.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//
import SwiftUI

struct HomePage: View {
    @State private var selectedCategory = "Random"
    @State private var authorName = ""
    
    @ObservedObject var quoteVM: QuoteViewModel
    
    let categories = [
        "Random": "random",
        "Daily": "today",
        "Author": "author"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        NavigationLink(destination: SavedImagesView()) {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        NavigationLink(destination: SavedQuotesView(savedQuotes: quoteVM.savedQuotes)) {
                            Image(systemName: "quote.bubble")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 10)
                    
                    Text("Welcome to the Quote Generator App!")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Picker("Select a Quote Category", selection: $selectedCategory) {
                        ForEach(categories.keys.sorted(), id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedCategory == "Author" {
                        TextField("Enter author name", text: $authorName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    Button("Get Quote") {
                        if selectedCategory == "Random" {
                            quoteVM.getQuoteRandom()
                        } else if selectedCategory == "Author" {
                            quoteVM.getQuoteByArtist(authorName: authorName)
                        } else if selectedCategory == "Image" {
                            quoteVM.getQuoteByImage()
                        } else if selectedCategory == "Daily" {
                            quoteVM.getDailyQuote()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if quoteVM.currentQuote == "" {
                        Text("Click the button to get a quote!")
                            .padding()
                            .multilineTextAlignment(.center)
                    } else {
                        Text(quoteVM.currentQuote)
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: quoteVM.saveQuote) {
                        HStack {
                            Image(systemName: "bookmark.fill")
                            Text("Save Quote")
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // Saved Quotes Page
    struct SavedQuotesView: View {
        let savedQuotes: [QuoteGenerator]
        
        var body: some View {
            VStack {
                Text("Saved Quotes")
                    .font(.title)
                    .padding()
                
                List(savedQuotes, id: \.id) { quote in
                    Text(quote.quote ?? "Unknown Quote")
                        .padding()
                }
            }
        }
    }
    
    // Placeholder for Saved Images Page
    struct SavedImagesView: View {
        var body: some View {
            VStack {
                Text("Saved Images")
                    .font(.title)
                    .padding()
                Spacer()
            }
        }
    }
    
    // Preview
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage(quoteVM: QuoteViewModel(quote: QuoteGenerator(quote: "Hello, World!", artist: "Author")))
        }
    }
}
