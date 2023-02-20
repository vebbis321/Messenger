//
//  JoinFacebookVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/20/23.
//

import SwiftUI

final class JoinFacebookVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // navBar
        navigationController?.navigationBar.topItem?.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)

        let childView = UIHostingController(rootView: JoinFacebookView())
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }


}
