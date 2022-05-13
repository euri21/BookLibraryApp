//
//  Tabs.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import Foundation
import SwiftUI

struct Tabs<Label: View>: View {
    
    @Binding var tabs: [String]
    @Binding var selection: Int
    let underlineColor: Color
    let label: (String, Bool) -> Label
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(tabs, id: \.self) {
                    self.tab(title: $0)
                }
            }.padding(.horizontal, 3)
        }
    }
    
    private func tab(title: String) -> some View {
        let index = self.tabs.firstIndex(of: title)!
        let isSelected = index == selection
        
        
        var tabWidth: CGFloat = 100.0
        if UIScreen.main.bounds.width > tabWidth * CGFloat(self.tabs.count) {
            tabWidth = UIScreen.main.bounds.width / CGFloat(self.tabs.count)
        }
        
        return Button(action: {
            withAnimation {
                self.selection = index
            }
        }) {
            label(title, isSelected)
                .font(.body)
                .padding(20)
                .frame(minWidth: tabWidth)
                .overlay(
                    Rectangle()
                        .frame(height: isSelected ? 5 : 1)
                        .foregroundColor(isSelected ? underlineColor : .gray)
                        .transition(.move(edge: .bottom)) ,alignment: .bottomLeading
                )
        }
    }
}
