//
//  ViewController.swift
//  Homework2
//
//  Created by Adrimi on 20/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var x: CGFloat = 0.0
    private var y: CGFloat = 0.0
    private var moonOffsetX: CGFloat = 80.0
    private var moonOffsetY: CGFloat = 80.0
    
    private final let moonSize: CGFloat = 150.0
    private final let moonParralaxStrength: CGFloat = 1.06
    
    var scrollView: CityScroller {
        return view as! CityScroller
    }
    var moonView: UIView!
    
    override func loadView() {
        view = CityScroller()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Necessary to make a moon hang in place
        scrollView.delegate = self
        
        moonView =
            UIView(frame:
                CGRect(origin: .zero, size:
                    CGSize(width: moonSize, height: moonSize)))
        moonView.center = CGPoint(x: moonSize / 1.5, y: moonSize / 1.5)
        moonView.backgroundColor = .white
        moonView.layer.cornerRadius = moonSize * 0.5
        scrollView.addSubview(moonView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.delegate = self
        moonView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(_ press: UILongPressGestureRecognizer) {
        switch press.state {

        case .began:
            //self.view.bringSubviewToFront(moonView)
            x = press.location(in: view).x - moonView.center.x
            y = press.location(in: view).y - moonView.center.y
            UIView.animate(withDuration: 0.2, animations: {
                self.moonView.alpha = 0.7
                self.moonView.transform = .init(scaleX: 1.2, y: 1.2)
            })
            
        case .changed:
            moonView.center.x = press.location(in: view).x - x
            moonView.center.y = press.location(in: view).y - y
            
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                self.moonView.alpha = 1
                self.moonView.transform = .identity
            })
            moonOffsetX = moonView.frame.origin.x - scrollView.contentOffset.x
            moonOffsetY = moonView.frame.origin.y - scrollView.contentOffset.y
            //self.view.sendSubviewToBack(moonView)
            
        default:
            print("Unknown state, where is the moon?!")
        }
    }
    
    private func getCentered() {
        moonView.frame.origin.x = scrollView.contentOffset.x + moonOffsetX
        // paralax effect
        moonView.frame.origin.y = scrollView.contentOffset.y * moonParralaxStrength + moonOffsetY
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        scrollView.setup(size: size)
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        getCentered()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UIPanGestureRecognizer
    }
}

