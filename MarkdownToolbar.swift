//
//  MarkdownToolbar.swift
//  RichTextEditor
//
//  Created by Azfar Imtiaz on 2024-10-21.
//

import SwiftUI

struct MarkdownToolbar: View {
    @Binding var text: String
    @Binding var selectedTextRange: NSRange?
    
    var body: some View {
        HStack {
            Button(action: applyBold) {
                Text("B")
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: applyItalic) {
                Text("I")
                    .italic()
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: applyStrikethrough) {
                Text("S")
                    .strikethrough()
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: applyHeading) {
                Text("H")
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: applyList) {
                Text("•")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    func applyBold() {
        applyMarkdownFormatting(wrapper: "**")
    }
    
    func applyItalic() {
        applyMarkdownFormatting(wrapper: "_")
    }
    
    func applyStrikethrough() {
        applyMarkdownFormatting(wrapper: "~~")
    }
    
    func applyCode() {
        applyMarkdownFormatting(wrapper: "`")
    }
    
    func applyHeading() {
        if let range = selectedTextRange, range.length > 0 {
            let startIndex = text.index(text.startIndex, offsetBy: range.location)
            text.insert(contentsOf: "# ", at: startIndex)
        }
    }
    
    func applyList() {
        if let range = selectedTextRange, range.length > 0 {
            let selectedText = (text as NSString).substring(with: selectedTextRange!)
            
            let lines = selectedText.components(separatedBy: .newlines)
            let bulletLines = lines.map { line in
                if line.trimmingCharacters(in: .whitespaces).isEmpty {
                    return line
                } else {
                    if !line.starts(with: "- ") {
                        return "- \(line)"
                    } else {
                        return line
                    }
                }
            }
            
            let newText = bulletLines.joined(separator: "\n")
            text = (text as NSString).replacingCharacters(in: selectedTextRange!, with: newText)
            
            // selectedTextRange?.length = newText.count
        }
    }
    
    func applyMarkdownFormatting(wrapper: String) {
        if let range = selectedTextRange, range.length > 0 {
            let startIndex = text.index(text.startIndex, offsetBy: range.location)
            let endIndex   = text.index(text.startIndex, offsetBy: range.length + range.location)
            let selectedText = String(text[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            var newText = ""
            // if formatting is already applied, remove it
            if selectedText.hasPrefix(wrapper) && selectedText.hasSuffix(wrapper) {
                newText = selectedText
                for _ in 0..<wrapper.count {
                    newText.removeFirst()
                    newText.removeLast()
                }
            }
            // if formatting is not applied, apply it
            else {
                newText = wrapper + selectedText + wrapper
            }
            text.replaceSubrange(startIndex..<endIndex, with: newText)
        }
    }
}
