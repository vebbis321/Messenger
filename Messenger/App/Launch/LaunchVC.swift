//
//  LaunchVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/1/23.
//

import SwiftUI

final class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: LaunchView())
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
