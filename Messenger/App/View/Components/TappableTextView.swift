//
//  SubLinkTextView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit

class TappableTextView: UITextView, UITextViewDelegate {

    typealias URLString = String
    typealias ShowURL = Bool
    typealias TappableTexts = [String: URLString?]
    typealias OnTextTap = () -> ShowURL


    var onTextTap: OnTextTap?

    override init(frame: CGRect = .zero, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
        font = .preferredFont(forTextStyle: .subheadline)
        backgroundColor = .theme.background
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addTappableTexts(_ tappableTexts: TappableTexts) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)

        for (text, optionalUrl) in tappableTexts {
            if text.count > 0 {
                let linkRange = mText.mutableString.range(of: text)
                mText.addAttribute(.link, value: optionalUrl ?? "", range: linkRange)
            }
        }
        attributedText = mText
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return onTextTap?() ?? true
    }

    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
