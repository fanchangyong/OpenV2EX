//
//  FullscreenViewController.swift
//  OpenV2EX
//
//  Created by fanchangyong on 3/22/23.
//

import Foundation
import UIKit

class FullscreenViewController: UIViewController {
    var image: UIImage?
    var currentScale: CGFloat = 1
    var currentAngle: CGFloat = 0
    let maxScale: CGFloat = 30
    let minScale: CGFloat = 1
    var originalCenter: CGPoint?

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        self.view.addSubview(iv)
        iv.frame = self.view.bounds
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureRecognized(_:)))
        iv.addGestureRecognizer(pinchGestureRecognizer)
        
        // Add a UIPanGestureRecognizer to the UIImageView
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        iv.addGestureRecognizer(panGestureRecognizer)
        
        return iv
    }()
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let imageView = gestureRecognizer.view as? UIImageView else {
            return
        }

        if gestureRecognizer.state == .began {
            // Save the original center of the UIImageView
            originalCenter = imageView.center
        } else if gestureRecognizer.state == .changed {
            // Get the translation of the gesture
            let translation = gestureRecognizer.translation(in: view)

            // Update the center of the UIImageView based on the translation
            imageView.center = CGPoint(x: (originalCenter?.x ?? 0) + translation.x,
                                        y: (originalCenter?.y ?? 0) + translation.y)
        }
    }
    
    @objc func pinchGestureRecognized(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else {
            return
        }

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let newScale = currentScale * gestureRecognizer.scale
            if newScale < maxScale && newScale > minScale {
                currentScale = newScale
                gestureRecognizer.scale = 1
                setImageViewTransform()
            }
        }
    }
    
    func setImageViewTransform() {
        imageView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale).rotated(by: currentAngle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.imageView.image = image
        view.addSubview(imageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationDidChange() {
        let newOrientation = UIDevice.current.orientation
        currentAngle = angle(for: newOrientation)
        
        UIView.animate(withDuration: 0.3) {
            self.setImageViewTransform()
        }
        self.imageView.frame = self.view.bounds
    }

    func angle(for orientation: UIDeviceOrientation?) -> CGFloat {
        guard let orientation = orientation else {
            return 0
        }
        
        switch orientation {
        case .portrait:
            return 0
        case .portraitUpsideDown:
            return .pi
        case .landscapeLeft:
            return .pi / 2
        case .landscapeRight:
            return -.pi / 2
        default:
            return 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissFullscreen() {
        dismiss(animated: true, completion: nil)
    }

}
