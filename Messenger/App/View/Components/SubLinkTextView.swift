//
//  SubLinkTextView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/22/23.
//

import UIKit

class SubLinkTextView: UITextView, UITextViewDelegate {

    typealias Links = [String: String]

    typealias OnLinkTap = (URL) -> Bool

    var onLinkTap: OnLinkTap?

    override init(frame: CGRect = .zero, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false //to have own size and behave like a label
        delegate = self
        font = .preferredFont(forTextStyle: .subheadline)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addLinks(_ links: Links) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)

        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        attributedText = mText
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return onLinkTap?(URL) ?? true
    }

    // to disable text selection
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
