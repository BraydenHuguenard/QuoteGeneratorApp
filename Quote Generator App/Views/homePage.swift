//
//  HomePage.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//
import SwiftUI

struct HomePage: View {
    @State private var quote = "Click the button to get a quote!"
    @State private var selectedCategory = "Random"
    @State private var authorName = ""
    
    @AppStorage("savedQuotes") private var savedQuotesData: String = ""
    @State private var savedQuotes: [String] = []
    
    let apiKey = "your_key"

    let categories = [
        "Random": "random",
        "Daily": "today",
        "Author": "author",
        "Image": "image",
    ]

    func fetchQuote() {
        guard let categoryEndpoint = categories[selectedCategory] else { return }

        var urlString: String

        if categoryEndpoint == "author" {
            let formattedAuthorName = authorName.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: " ", with: "_")
            guard !formattedAuthorName.isEmpty else {
                quote = "Please enter an author's name."
                return
            }
            urlString = "https://zenquotes.io/api/quotes/author/\(formattedAuthorName)/\(apiKey)"
        } else if categoryEndpoint == "image" {
            
            urlString = "https://zenquotes.io/api/image/"
        } else {
            urlString = "https://zenquotes.io/api/\(categoryEndpoint)/\(apiKey)"
        }

        guard let url = URL(string: urlString) else {
            quote = "Invalid URL. Please try again."
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONSerialization.jsonObject(with: data) as? [[String: String]],
               let firstQuote = result.first?["q"] {
                DispatchQueue.main.async {
                    quote = firstQuote
                }
            } else {
                DispatchQueue.main.async {
                    quote = "Failed to fetch quote. Try again."
                }
            }
        }.resume()
    }

    
    func saveQuote() {
        if !savedQuotes.contains(quote) {
            savedQuotes.append(quote)
            saveQuotesToStorage()
        }
    }

    func saveQuotesToStorage() {
        if let encoded = try? JSONEncoder().encode(savedQuotes),
           let jsonString = String(data: encoded, encoding: .utf8) {
            savedQuotesData = jsonString
        }
    }

    func loadSavedQuotes() {
        if let data = savedQuotesData.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            savedQuotes = decoded
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        // Two blue buttons on the left
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
                        
                        NavigationLink(destination: SavedQuotesView(savedQuotes: savedQuotes)) {
                            Image(systemName: "quote.bubble")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Star button on the right
                        Button(action: saveQuote) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Circle().fill(Color.yellow))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                   
                    Text(quote)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
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
                    
                    // Button to fetch a quote or image
                    Button("Get Quote") {
                        fetchQuote()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: loadSavedQuotes)
        }
    }
}


struct SavedQuotesView: View {
    let savedQuotes: [String]

    var body: some View {
        VStack {
            Text("Saved Quotes")
                .font(.title)
                .padding()

            List(savedQuotes, id: \.self) { quote in
                Text(quote)
                    .padding()
            }
        }
    }
}


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


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
