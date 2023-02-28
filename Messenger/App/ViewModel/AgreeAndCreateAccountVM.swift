//
//  AgreeAndCreateAccountVM.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/28/23.
//

import Foundation

final class AgreeAndCreateAccountVM {
    var textItemVms: [AgreeAndCreateAccountItemVM]!

    init() {
        createTextItemVms()
    }
}

// MARK: - textItemVms
extension AgreeAndCreateAccountVM {
    struct AgreeAndCreateAccountItemVM {
        let text: String
        let tappableTextAndUrlString: [String: String]
    }

    private func createTextItemVms() {
        textItemVms = [
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Learn more" : "https://www.facebook.com/policies_center"]
            ),
            .init(
                text: "By tapping I agree, you agree to create an account and to Facebook's terms. Learn how we collect, use and share your data in our Privacy Policy and how we use cookies and similar technology in our Cookies Policy.",
                tappableTextAndUrlString: [
                    "terms.": "https://www.facebook.com/policies_center",
                    "Privacy Policy": "https://www.facebook.com/policies_center",
                    "Cookies Policy.": "https://www.facebook.com/policies_center"
                ]
            ),
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Privacy Policy" : "https://www.facebook.com/policies_center"]
            ),
            .init(
                text: "People who use our service may have uploaded your contact information to Facebook. Learn more",
                tappableTextAndUrlString: ["Learn more" : "https://www.facebook.com/policies_center"]
            )
        ]
    }

}
