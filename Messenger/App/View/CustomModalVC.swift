//
//  CustomModalVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/27/23.
//

import UIKit

final class CustomModalVC: UIViewController {

    private lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()

    private var customView: UIView

    private let customHeight = UIScreen.main.bounds.height * 0.75
    private var isPresenting = false
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?

    init(customView: UIView) {
        self.customView = customView
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()

    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = customView.frame.origin
        }
        presentingViewController?.view.roundCorners([.topLeft, .topRight], radius: 12)
        customView.roundCorners([.topLeft, .topRight], radius: 8)
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: customView)

        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }

        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        customView.frame.origin = CGPoint(x: 0, y: pointOrigin!.y + translation.y)

        let draggedToDismiss = (translation.y > customView.frame.height / 2.0)
        let dragVelocity = sender.velocity(in: customView)

        switch sender.state {
        case .changed:
            let percentage: CGFloat = translation.y / customHeight
            backdropView.alpha = 1 - percentage

            if let presentingViewController = presentingViewController {
                let scale = (0.05 * percentage) + 0.95
                presentingViewController.view.transform = .init(scaleX: scale, y: scale)
            }

            // handle fast swipe upe
            if dragVelocity.y < -3000 {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.45, delay: 0, options: [.curveEaseOut]) { [weak self] in
                    self?.customView.frame.origin = self?.pointOrigin ?? CGPoint(x: 0, y: 400)
                    self?.backdropView.alpha = 1
                    self?.presentingViewController?.view.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }
        case .ended:
            // is it as fast swipe or dragged to dismissed
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.customView.frame.origin = self?.pointOrigin ?? CGPoint(x: 0, y: 400)
                    self?.backdropView.alpha = 1
                    self?.presentingViewController?.view.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }

        @unknown default:
            break
        }

    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout
private extension CustomModalVC {
    private func setUpLayout() {

        // self

        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(customView)

        // customView
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.heightAnchor.constraint(equalToConstant: customHeight).isActive = true
        customView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backdropView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        customView.addGestureRecognizer(panGesture)
    }
}

extension CustomModalVC: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting

        if isPresenting == true {
            containerView.addSubview(toVC.view)

            customView.frame.origin.y += customHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.customView.frame.origin.y -= self.customHeight
                self.backdropView.alpha = 1
                self.presentingViewController?.view.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.customView.frame.origin.y += self.customHeight
                self.backdropView.alpha = 0
                self.presentingViewController?.view.transform = .identity
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
