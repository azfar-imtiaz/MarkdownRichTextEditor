//
//  RichTextEditor.swift
//  RichTextEditor
//
//  Created by Azfar Imtiaz on 2024-10-18.
//

import SwiftUI
import UIKit
import SwiftyMarkdown


struct RichTextEditor: UIViewRepresentable {
    @Binding var text          : String
    @Binding var isEditing     : Bool
    @Binding var selectedRange : NSRange?
    @Binding var isFocused     : Bool
    
    let defaultFontSize: CGFloat = 16
    
    var onTextChange: ((String) -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: defaultFontSize)
        
        textView.delegate = context.coordinator
        
        // textView.addDoneButton(title: "Done", target: textView, selector: #selector(textView.addDoneButtonTapped(button:)))
        
        // START MARK: ===========================================
        textView.addToolbarWithButtons(
            doneAction: {
                textView.resignFirstResponder()
            },
            boldAction: {
                self.applyBold()
            },
            italicAction: {
                self.applyItalic()
            },
            strikethroughAction: {
                self.applyStrikethrough()
            },
            headingAction: {
                self.applyHeading()
            },
            bulletPointsAction: {
                self.applyList()
            }
        )
        // END MARK: ===========================================
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        if isEditing {
            if textView.font?.pointSize != defaultFontSize {
                textView.font = UIFont.systemFont(ofSize: defaultFontSize)
            }
            textView.text = text
        } else {
            let markdown = SwiftyMarkdown(string: text)
            markdown.body.fontName = "Helvetica"
            markdown.bold.fontName = "Helvetica-Bold"
            markdown.italic.fontName = "Helvetica-Oblique"
            markdown.strikethrough.fontName = "Helvetica"
            markdown.strikethrough.fontStyle = .normal
            
            textView.attributedText = markdown.attributedString()            
        }
        
        if isFocused && !textView.isFirstResponder {
            DispatchQueue.main.async {
                textView.becomeFirstResponder()
            }
        } else if !isFocused && textView.isFirstResponder {
            DispatchQueue.main.async {
                textView.resignFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        var didFocusChange = false
        
        init(parent: RichTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.selectedRange = textView.selectedRange
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if !didFocusChange {
                textView.attributedText = stripStrikethroughAndBlockquote(from: textView.attributedText)
                parent.isEditing = true
                parent.isFocused = true
                didFocusChange = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if didFocusChange {
                parent.isEditing = false
                parent.isFocused = false
                
                // Is this required?
                // parent.text = textView.text
                didFocusChange = false
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            parent.selectedRange = textView.selectedRange	
        }
        
        // Add the method to strip strikethrough and blockquote attributes
        private func stripStrikethroughAndBlockquote(from attributedString: NSAttributedString) -> NSAttributedString {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            // Iterate over all attributes in the string
            mutableAttributedString.enumerateAttributes(in: NSRange(location: 0, length: mutableAttributedString.length)) { attributes, range, _ in
                if attributes[.strikethroughStyle] != nil || attributes[.paragraphStyle] != nil {
                    // Remove strikethrough or blockquote style
                    mutableAttributedString.removeAttribute(.strikethroughStyle, range: range)
                    mutableAttributedString.removeAttribute(.paragraphStyle, range: range)
                }
            }
            
            return mutableAttributedString
        }
    }
    
    // START MARK: =========================================
    
    func applyBold() {
        applyMarkdownFormatting(wrapper: "**")
    }
    
    func applyItalic() {
        applyMarkdownFormatting(wrapper: "_")
    }
    
    func applyStrikethrough() {
        applyMarkdownFormatting(wrapper: "~~")
    }
    
    func applyHeading() {
        if let range = selectedRange, range.length > 0 {
            let startIndex = text.index(text.startIndex, offsetBy: range.location)
            text.insert(contentsOf: "# ", at: startIndex)
        }
    }
    
    func applyList() {
        if let range = selectedRange, range.length > 0 {
            let selectedText = (text as NSString).substring(with: selectedRange!)
            
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
            text = (text as NSString).replacingCharacters(in: selectedRange!, with: newText)
            
            // selectedTextRange?.length = newText.count
        }
    }
    
    func applyMarkdownFormatting(wrapper: String) {
        if let range = selectedRange, range.length > 0 {
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
    // END MARK: ===========================================
}
