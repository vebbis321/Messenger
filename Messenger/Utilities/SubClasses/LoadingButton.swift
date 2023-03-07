//
//  LoadingButton.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 3/7/23.
//

import UIKit

protocol LoadingButtonProtocol: UIButton {
    var text: String { get set }
    var activityIndicator: UIActivityIndicatorView { get set }
}

public class LoadingButton: UIButton, LoadingButtonProtocol {
    var text: String = ""
    var activityIndicator: UIActivityIndicatorView = .init(style: .medium)

}
