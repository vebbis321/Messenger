//
//  DefaultCreateAccountView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/21/23.
//

import SwiftUI

struct DefaultCreateAccountView<Content: View>: View {

    var title: String
    var vcPopped: (()->())

    @ViewBuilder var content: Content
    @State var showAlert = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(.all)

            VStack(alignment: .center, spacing: 20) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.theme.tintColor)

                content

                Spacer()

                Button {
                    showAlert.toggle()
                } label: {
                    Text("Already have an account?")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.theme.hyperlink)
                }

            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .modify {
            if #available(iOS 15, *) {
                $0
                    .alert("Already have an account?", isPresented: $showAlert) {
                        Button {
                            vcPopped()
                        } label: {
                            Text("Log in")
                                .foregroundColor(.theme.hyperlink)
                                .fontWeight(.bold)
                        }

                        Button("Continue creating account", role: .none) {}
                    }
            } else {
                $0
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Already have an account?"),
                            primaryButton: .default(Text("Continue creating account"), action: {}),
                            secondaryButton: .cancel(Text("Log in"), action: {

                            })
                        )
                    }
            }
        }
    }
}

