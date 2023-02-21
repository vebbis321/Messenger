//
//  JoinFacebookView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import SwiftUI

struct JoinFacebookView: View {

    var getStartedTapped: (()->())?
    var vcPopped: (()->())

    var body: some View {

        DefaultCreateAccountView(title: "Join Facebook to use\nMessenger", vcPopped: vcPopped) {
            Image("CreateFacebookAccount")
                .resizable()
                .scaledToFit()
                .cornerRadius(3)

            Text("You'll need a Facebook account to use Messenger. Create an account to connect with friends, family and people who share your interests.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 15, weight: .regular))

            AuthButtonView(title: "Get Started") {
                getStartedTapped?()
            }
        }
    }
}
