//
//  ContentView.swift
//  MC2_ScolioSense
//
//  Created by Lisandra Nicoline on 22/05/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
    
