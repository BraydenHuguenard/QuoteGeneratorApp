//
//  HomePage.swift
//  Quote Generator App
//
//  Created by Brayden Huguenard on 3/7/25.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var quoteVM = QuoteViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    HomePage()
}
