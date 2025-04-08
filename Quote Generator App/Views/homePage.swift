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
                        
                        NavigationLink(destination: SavedQuotesView(quoteVM: quoteVM)) {
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
                        
                    if quoteVM.currentQuote.isEmpty {
                        Text("Click the button to get a quote!")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(quoteVM.currentQuote)
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
        @ObservedObject var quoteVM: QuoteViewModel

        var body: some View {
            VStack(alignment: .center) {
                Text("Saved Quotes")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .padding(.top)

                List {
                    ForEach(quoteVM.savedQuotes, id: \.id) { quote in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(quote.quote ?? "Unknown Quote")
                                .font(.body)
                                .padding(.vertical, 8)
                        }
                    }
                    .onDelete(perform: deleteQuote)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }

        func deleteQuote(at offsets: IndexSet) {
            quoteVM.savedQuotes.remove(atOffsets: offsets)
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

