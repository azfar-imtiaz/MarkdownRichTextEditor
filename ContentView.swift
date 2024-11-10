//
//  ContentView.swift
//  RichTextEditor
//
//  Created by Azfar Imtiaz on 2024-10-18.
//

import SwiftUI
import UIKit

struct ContentView: View {
    // @StateObject private var viewModel = TextEditorViewModel()
    @State var text: String = ""
    @State var isEditing: Bool = false
    @State var selectedTextRange: NSRange? = nil
    @State var isFocused: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                RichTextEditor(
                    text: $text,
                    isEditing: $isEditing,
                    selectedRange: $selectedTextRange,
                    isFocused: $isFocused,
                    onTextChange: { newText in
                        text = newText
                    }
                )
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 2)
                )
                
                Spacer()
                
                // MarkdownToolbar(text: $text, selectedTextRange: $selectedTextRange)
            }
            .padding()
            .navigationTitle("Markdown Rich Editor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
