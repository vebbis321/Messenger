//
//  ResizedVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/25/23.
//

import UIKit

class HalfScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.view.alpha = 0.3
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1) {
            self.presentingViewController?.view.alpha += 0.01
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentingViewController?.view.alpha = 1
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.frame = .init(x: 0, y: view.frame.height * 0.25, width: view.frame.width, height: UIScreen.main.bounds.height)
    }





}


