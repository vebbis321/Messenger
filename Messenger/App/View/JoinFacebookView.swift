//
//  JoinFacebookView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import SwiftUI

struct JoinFacebookView: View {

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(.all)

            VStack(alignment: .center, spacing: 15) {
                Text("Join Facebook to use\nMessenger")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25, weight: .bold))

                Image("CreateFacebookAccount")
                    .resizable()
                    .scaledToFit()

                Text("You'll need a Facebook account to use Messenger. Create an account to connect with friends, family and people who share your interests.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15, weight: .regular))

                AuthButtonView(title: "Get Started") {
                    print("TAppe dme")
                }
                
                Spacer()

                Button {

                } label: {
                    Text("Already have an account?")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue)
                }

            }.padding(.horizontal, 15)
        }
    }
}
