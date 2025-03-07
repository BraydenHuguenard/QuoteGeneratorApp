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
            Text("Quote Generator App!!")
        }
        .padding()
    }
}

#Preview {
    HomePage()
}
