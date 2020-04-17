//
//  MultilineTextField.swift
//  AyudaPY
//
//  Created by Victor on 4/16/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    let make: (Coordinator) -> UIViewType
    let update: (UIViewType, Coordinator) -> Void
    
    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UIViewType {
        return make(context.coordinator)
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<TextView>) {
        update(uiView, context.coordinator)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {

        var text: Binding<String> = .constant("")
        var width: CGFloat = 0
        var height: Binding<CGFloat?> = .constant(nil)
        var cursor: Binding<CGFloat?> = .constant(nil)
        
        func textViewDidChange(_ textView: UITextView) {
            if text.wrappedValue != textView.text {
                text.wrappedValue = textView.text
            }
            adjustHeight(view: textView)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            OperationQueue.main.addOperation { [weak self] in
                self?.cursor.wrappedValue = self?.absoleteCursor(view: textView)
            }
        }
        
        func adjustHeight(view: UITextView) {
            let bounds = CGSize(width: width, height: .infinity)
            let height = view.sizeThatFits(bounds).height
            OperationQueue.main.addOperation { [weak self] in
                self?.height.wrappedValue = height
            }
        }
        
        func absoleteCursor(view: UITextView) -> CGFloat? {
            guard let range = view.selectedTextRange else {
                return nil
            }
            let caretRect = view.caretRect(for: range.end)
            let windowRect = view.convert(caretRect, to: nil)
            return windowRect.origin.y + windowRect.height
        }
        
    }
}

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?
    let textField = UITextView()
    
    @Binding var currentForm: Int
    var formId:Int
    var keyboard:UIKeyboardType
    var autoCapitalization:UITextAutocapitalizationType
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        textField.delegate = context.coordinator
        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        
        if nil != onDone {
            textField.returnKeyType = .done
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        if(currentForm == formId){
        textField.becomeFirstResponder()
        }
        
        textField.keyboardType = keyboard
        textField.autocapitalizationType = autoCapitalization
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UITextViewWrapper.recalculateHeight(view: self.textField, result: self.$calculatedHeight)
        }
        
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder, currentForm == formId{
            uiView.becomeFirstResponder()
        }
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}

struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?
    
    @Binding private var text: String
    @Binding var currentForm: Int
    var formId:Int
    var keyboard:UIKeyboardType
    var autoCapitalization:UITextAutocapitalizationType
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    
    init (_ placeholder: String = "", text: Binding<String>, currentForm: Binding<Int>, formId: Int, keyboard:UIKeyboardType,autoCapitalization:UITextAutocapitalizationType, onCommit: (() -> Void)? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._currentForm = currentForm
        self.formId = formId
        self.keyboard = keyboard
        self.autoCapitalization = autoCapitalization
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit, currentForm: $currentForm, formId: formId, keyboard: keyboard, autoCapitalization: autoCapitalization)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .frame(height: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
