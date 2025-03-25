//
//  HomePage.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//
import SwiftUI

struct HomePage: View {
    @State private var quote = "Click the button to get a quote!"
    @State private var selectedCategory = "random"
    
    let categories = [
        "Random": "random",
        "Motivational": "motivational",
        "Love": "love",
        "Life": "life"
    ]
    
    func fetchQuote() {
        guard let categoryEndpoint = categories[selectedCategory] else { return }
        let url = URL(string: "https://zenquotes.io/api/\(categoryEndpoint)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let result = try? JSONSerialization.jsonObject(with: data) as? [[String: String]],
               let firstQuote = result.first?["q"] {
                DispatchQueue.main.async {
                    quote = firstQuote
                }
            }
        }.resume()
    }
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                Text("Welcome to the Quote Generator App!")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .padding(.horizontal, 20)
                
                Spacer()

                // Picker to select a category
                Picker("Select a Quote Category", selection: $selectedCategory) {
                    ForEach(categories.keys.sorted(), id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Make it a segmented control
                .padding()

                Button("Get Quote") {
                    fetchQuote()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Text(quote)
                    .padding()
                    .multilineTextAlignment(.center)

                Spacer()
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
