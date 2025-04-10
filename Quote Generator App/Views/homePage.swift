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
                        NavigationLink(destination: SavedImagesView(quoteVM: quoteVM)) {
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
                        
                    if let imageData = quoteVM.quote.imageData,
                       !imageData.isEmpty,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .padding()
                            .frame(height: 300)
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
                            HStack {
                              Spacer()
                              Text("Saved on: \(quote.dateSaved)")
                                  .font(.footnote)
                                  .foregroundColor(.gray)
                            }
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
        @ObservedObject var quoteVM: QuoteViewModel
        @State private var currentIndex: Int = 0
        
        var body: some View {
            VStack {
                Text("Saved Images")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                if quoteVM.savedImages.isEmpty {
                    Text("No saved images.")
                        .foregroundColor(.gray)
                } else {
                    if quoteVM.savedImages[currentIndex].image != nil {
                        Image(quoteVM.savedImages[currentIndex].image!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .padding()
                        HStack {
                            Button(action: {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }) {
                                Image(systemName: "chevron.left.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(currentIndex > 0 ? .blue : .gray)
                            }
                            .disabled(currentIndex == 0)
                            
                            Spacer()
                            
                            Button(action: {
                                if currentIndex < quoteVM.savedImages.count - 1 {
                                    currentIndex += 1
                                }
                            }) {
                                Image(systemName: "chevron.right.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(currentIndex < quoteVM.savedImages.count - 1 ? .blue : .gray)
                            }
                            .disabled(currentIndex == quoteVM.savedImages.count - 1)
                        }
                        .padding(.horizontal, 50)
                        .padding(.top)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage(quoteVM: QuoteViewModel(quote: QuoteGenerator(quote: "Hello, World!", artist: "Author")))
        }
    }
} 
