//
//  HomePage.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//
import SwiftUI

struct HomePage: View {
    @State private var selectedCategory = "Random"
    @ObservedObject var quoteVM: QuoteViewModel
    
    let categories = [
        "Random": "random",
        "Daily": "today",
        "Image" : "image"
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
                        
                        Spacer()
                        
                        Button(action: quoteVM.saveQuote) {
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
                    Spacer()
                        
                    if let imageData = quoteVM.quote.imageData,
                       !imageData.isEmpty,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .padding()
                            .frame(height: 250)
                    } else if !quoteVM.currentQuote.isEmpty {
                        Text(quoteVM.currentQuote)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("Click the button to get a quote!")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    
                    Spacer()
                    Spacer()
                    
                    Picker("Select a Quote Category", selection: $selectedCategory) {
                        ForEach(categories.keys.sorted(), id: \..self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button("Get Quote") {
                        if selectedCategory == "Random" {
                            quoteVM.getQuoteRandom()
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
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    struct SavedQuotesView: View {
        let savedQuotes: [QuoteGenerator]
        
        var body: some View {
            VStack {
                Text("Saved Quotes")
                    .font(.title)
                    .padding()
                
                List(savedQuotes, id: \..id) { quote in
                    Text(quote.quote ?? "Unknown Quote")
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
            HomePage(quoteVM: QuoteViewModel(quote: QuoteGenerator(quote: "Hello, World!", artist: "Author")))
        }
    }
}

