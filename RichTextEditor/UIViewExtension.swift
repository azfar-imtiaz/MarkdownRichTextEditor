//
//  UIViewExtension.swift
//  RichTextEditor
//
//  Created by Azfar Imtiaz on 2024-10-21.
//

import Foundation
import SwiftUI

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolbar.isTranslucent = true
        toolbar.tintColor = .white
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolbar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolbar
    }
    
    @objc func addDoneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
    // START MARK: ========================================================
    
    func addToolbarWithButtons (
        doneAction: @escaping () -> Void,
        boldAction: @escaping () -> Void,
        italicAction: @escaping () -> Void,
        strikethroughAction: @escaping () -> Void,
        headingAction: @escaping () -> Void,
        bulletPointsAction: @escaping () -> Void
    ) {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolbar.isTranslucent = true
        toolbar.tintColor = .white
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let boldButton = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .plain, target: nil, action: #selector(executeBold))
        boldButton.tintColor = .systemBlue
        let italicButton = UIBarButtonItem(image: UIImage(systemName: "italic"), style: .plain, target: nil, action: #selector(executeItalic))
        italicButton.tintColor = .systemBlue
        let strikethroughButton = UIBarButtonItem(image: UIImage(systemName: "strikethrough"), style: .plain, target: nil, action: #selector(executeStrikethrough))
        strikethroughButton.tintColor = .systemBlue
        let headingButton = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: nil, action: #selector(executeHeading))
        headingButton.tintColor = .systemBlue
        let bulletPointsButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: nil, action: #selector(executeBulletPoints))
        bulletPointsButton.tintColor = .systemBlue
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: nil, action: #selector(executeDone))
        
        objc_setAssociatedObject(self, &AssociatedKeys.boldClosureKey, boldAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.italicClosureKey, italicAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.strikethroughClosureKey, strikethroughAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.headingClosureKey, headingAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.bulletPointsClosureKey, bulletPointsAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.doneClosureKey, doneAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        toolbar.setItems([
            boldButton, flexibleSpace,
            italicButton, flexibleSpace,
            strikethroughButton, flexibleSpace,
            headingButton, flexibleSpace,
            bulletPointsButton, flexibleSpace,
            doneButton
        ], animated: false)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc private func executeBold() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.boldClosureKey) as? () -> Void {
            action()
        }
    }
    
    @objc private func executeItalic() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.italicClosureKey) as? () -> Void {
            action()
        }
    }
    
    @objc private func executeStrikethrough() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.strikethroughClosureKey) as? () -> Void {
            action()
        }
    }
    
    @objc private func executeHeading() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.headingClosureKey) as? () -> Void {
            action()
        }
    }
    
    @objc private func executeBulletPoints() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.bulletPointsClosureKey) as? () -> Void {
            action()
        }
    }
    
    @objc private func executeDone() {
        if let action = objc_getAssociatedObject(self, &AssociatedKeys.doneClosureKey) as? () -> Void {
            action()
        }
    }
}


//private struct AssociatedKeys {
//    static var boldClosure = "boldClosure"
//    static var italicClosure = "italicClosure"
//    static var strikethroughClosure = "strikethroughClosure"
//    static var headingClosure = "headingClosure"
//    static var bulletPointsClosure = "bulletPointsClosure"
//    static var doneClosure = "doneClosure"
//}

class AssociatedKeys {
    static var boldClosureKey: UInt8 = 0
    static var italicClosureKey: UInt8 = 1
    static var strikethroughClosureKey: UInt8 = 2
    static var headingClosureKey: UInt8 = 3
    static var bulletPointsClosureKey: UInt8 = 4
    static var doneClosureKey: UInt8 = 5
}

// END MARK: ========================================================
