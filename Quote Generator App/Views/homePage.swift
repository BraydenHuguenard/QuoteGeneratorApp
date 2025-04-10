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
                        
                        Button(action: {
                            if let imageData = quoteVM.quote.imageData, !imageData.isEmpty {
                                // Save as image quote
                                if !quoteVM.savedImages.contains(where: { $0.imageData == imageData }) {
                                    var imageQuote = quoteVM.quote
                                    imageQuote.setdateSaved()
                                    quoteVM.savedImages.append(imageQuote)
                                }
                            } else {
                                // Save as text quote
                                quoteVM.saveQuote()
                            }
                        }) {
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
                            .frame(height: 325)
                    } else if !quoteVM.currentQuote.isEmpty {
                        Text(quoteVM.currentQuote)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(height: 325)
                    } else {
                        Text("Click the button to get a quote!")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(height: 325)
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
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    struct SavedQuotesView: View {
        @ObservedObject var quoteVM: QuoteViewModel

        var body: some View {
            VStack(alignment: .center, spacing: 16) {
                Text("Saved Quotes")
                    .font(.largeTitle.bold())
                    .padding(.top)

                if quoteVM.savedQuotes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))

                        Text("No saved quotes yet.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                } else {
                    List {
                        ForEach(quoteVM.savedQuotes, id: \.id) { quote in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("“\(quote.quote ?? "Unknown Quote")”")
                                    .font(.body)
                                    .foregroundColor(.primary)

                                HStack {
                                    Spacer()
                                    Text("Saved on \(quote.dateSaved)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .onDelete(perform: deleteQuote)
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }

        func deleteQuote(at offsets: IndexSet) {
            quoteVM.savedQuotes.remove(atOffsets: offsets)
        }
    }
    
    struct SavedImagesView: View {
        @ObservedObject var quoteVM: QuoteViewModel
        @State private var currentIndex: Int = 0

        var body: some View {
            VStack(spacing: 20) {
                Text("Saved Images")
                    .font(.largeTitle.bold())
                    .padding(.top)

                if quoteVM.savedImages.isEmpty {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No saved images.")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                    .padding()
                } else {
                    if let data = quoteVM.savedImages[currentIndex].imageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 325)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    } else {
                        Text("Image could not be loaded.")
                            .foregroundColor(.red)
                            .padding()
                    }

                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .foregroundColor(currentIndex > 0 ? .blue : .gray.opacity(0.5))
                        }
                        .disabled(currentIndex == 0)

                        Text("\(currentIndex + 1) of \(quoteVM.savedImages.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        Button(action: {
                            if currentIndex < quoteVM.savedImages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .foregroundColor(currentIndex < quoteVM.savedImages.count - 1 ? .blue : .gray.opacity(0.5))
                        }
                        .disabled(currentIndex == quoteVM.savedImages.count - 1)
                    }
                    .padding(.top)

                    Button(action: deleteCurrentImage) {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding()
        }

        func deleteCurrentImage() {
            guard !quoteVM.savedImages.isEmpty else { return }

            quoteVM.savedImages.remove(at: currentIndex)

            if currentIndex >= quoteVM.savedImages.count {
                currentIndex = max(0, quoteVM.savedImages.count - 1)
            }
        }
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage(quoteVM: QuoteViewModel(quote: QuoteGenerator(quote: "Hello, World!")))
        }
    }
} 
