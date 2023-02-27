//
//  CustomOverlayView.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/25/23.
//

import UIKit

class CustomOverlayVC<CustomContentView: UIView>: UIViewController {

    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?

    private let handler = SheetHandlerView()
    private let contentView = CustomContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = view.frame.origin
        }
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }

        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: pointOrigin!.y + translation.y)

        if sender.state == .ended {
            let draggedToDismiss = (translation.y > view.frame.size.height/3.0)
            let dragVelocity = sender.velocity(in: view)
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.frame.origin = self?.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

// MARK: - Views
private extension CustomOverlayVC {
    private func setUpViews() {
        view.backgroundColor = .systemBackground
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        view.addSubview(handler)
        view.addSubview(contentView)
    }
}

private extension CustomOverlayVC {
    private func setUpConstraints() {
        handler.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        handler.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: handler.bottomAnchor, constant: 10).isActive = true
        contentView.pinSides(to: view, padding: 15)
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

