//
//  CustomModalVC.swift
//  Messenger
//
//  Created by Vebjørn Daniloff on 2/27/23.
//

import UIKit

final class CustomModalVC: UIViewController {

    let presentingVcMinScale: CGFloat = 0.9

    private lazy var backdropView: UIView = {
        let bdView = UIView(frame: view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    private lazy var modalContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private lazy var handle: UIView = {
        let handle = UIView(frame: .zero)
        handle.backgroundColor = .lightGray.withAlphaComponent(0.65)
        handle.layer.masksToBounds = true
        return handle
    }()
    private var closeButton: UIButton = .createIconButton(icon: "xmakr", weight: .semibold)
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
        handle.roundCorners(.allCorners, radius: 10)

        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = modalContainerView.frame.origin
        }
        presentingViewController?.view.roundCorners([.topLeft, .topRight], radius: 10)
        modalContainerView.roundCorners([.topLeft, .topRight], radius: 5)
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: modalContainerView)

        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }

        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        modalContainerView.frame.origin = CGPoint(x: 0, y: pointOrigin!.y + translation.y)

        let draggedToDismiss = (translation.y > modalContainerView.frame.height / 2.0)
        let dragVelocity = sender.velocity(in: modalContainerView)


        if sender.state == .changed {
            let percentage: CGFloat = translation.y / customHeight
            backdropView.alpha = 1 - percentage

            if let presentingViewController = presentingViewController {
                let scale = ((1 - presentingVcMinScale) * percentage) + presentingVcMinScale
                presentingViewController.view.transform = .init(scaleX: scale, y: scale)
            }

            // handle fast swipe upe
            if dragVelocity.y < -3000 {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.45, delay: 0, options: [.curveEaseOut]) { [weak self] in
                    guard let self = self else { return }
                    self.modalContainerView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                    self.backdropView.alpha = 1
                    self.presentingViewController?.view.transform = .init(scaleX: self.presentingVcMinScale, y: self.presentingVcMinScale)
                }
            }
        } else if sender.state == .ended {
            // is it as fast swipe or dragged to dismissed
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.modalContainerView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                    self.backdropView.alpha = 1
                    self.presentingViewController?.view.transform = .init(scaleX: self.presentingVcMinScale, y: self.presentingVcMinScale)
                }
            }
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
        view.addSubview(modalContainerView)

        // containerView
        modalContainerView.addSubview(handle)
        modalContainerView.addSubview(closeButton)
        modalContainerView.addSubview(customView)

        modalContainerView.translatesAutoresizingMaskIntoConstraints = false
        modalContainerView.heightAnchor.constraint(equalToConstant: customHeight).isActive = true
        modalContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        modalContainerView.pinSides(to: view)

        // handle
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.widthAnchor.constraint(equalToConstant: 40).isActive = true
        handle.heightAnchor.constraint(equalToConstant: 4).isActive = true
        handle.topAnchor.constraint(equalTo: modalContainerView.topAnchor, constant: 8).isActive = true
        handle.centerXAnchor.constraint(equalTo: modalContainerView.centerXAnchor).isActive = true

        // closeButton
        closeButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        closeButton.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 20).isActive = true
        closeButton.leftAnchor.constraint(equalTo: modalContainerView.leftAnchor, constant: 20).isActive = true

        // customView
        customView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        customView.pinSides(to: modalContainerView, padding: 20)
        customView.bottomAnchor.constraint(equalTo: modalContainerView.bottomAnchor, constant: -20).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backdropView.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        modalContainerView.addGestureRecognizer(panGesture)
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

            modalContainerView.frame.origin.y += customHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.modalContainerView.frame.origin.y -= self.customHeight
                self.backdropView.alpha = 1
                self.presentingViewController?.view.transform = .init(scaleX: self.presentingVcMinScale, y: self.presentingVcMinScale)
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.modalContainerView.frame.origin.y += self.customHeight
                self.backdropView.alpha = 0
                self.presentingViewController?.view.transform = .identity
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
