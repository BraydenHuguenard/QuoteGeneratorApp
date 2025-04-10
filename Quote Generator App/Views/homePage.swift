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
                        ForEach(categories.keys.sorted(), id: \.self) { key in
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

                List(savedQuotes, id: \.id) { quote in
                    VStack(alignment: .leading) {
                        Text(quote.quote ?? "Unknown Quote")
                            .padding(.bottom, 2)

                        HStack {
                            Spacer()
                            Text("Saved on: \(quote.dateSaved)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    struct SavedImagesView: View {
        // Placeholder image names – replace with actual image handling logic
        @State private var savedImages: [String] = ["image1", "image2", "image3"]
        @State private var currentIndex: Int = 0

        var body: some View {
            VStack {
                Text("Saved Images")
                    .font(.title)
                    .padding()

                Spacer()

                if savedImages.isEmpty {
                    Text("No saved images.")
                        .foregroundColor(.gray)
                } else {
                    Image(savedImages[currentIndex])
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
                            if currentIndex < savedImages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(currentIndex < savedImages.count - 1 ? .blue : .gray)
                        }
                        .disabled(currentIndex == savedImages.count - 1)
                    }
                    .padding(.horizontal, 50)
                    .padding(.top)
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
