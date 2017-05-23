//
//  AnimateToDetailVCController.swift
//  WeatherWonder
//
//  Created by Nathan Birkholz on 5/19/17.
//  Copyright © 2017 natebirkholz. All rights reserved.
//

import UIKit

class AnimateToDetailVCController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        guard let selectedRow = fromViewController.tableView.indexPathForSelectedRow else {
            assertionFailure("no row selected in tableview")
            return
        }
        let selectedCell = fromViewController.tableView.cellForRow(at: selectedRow) as! WeatherCell
        guard let weatherSnapshot = selectedCell.snapshotView(afterScreenUpdates: false) else {
            assertionFailure("Unable to snapshot the selected cell")
            return
        }

        weatherSnapshot.frame = containerView.convert(selectedCell.bounds, from: fromViewController.tableView.cellForRow(at: selectedRow))
        selectedCell.alpha = 0
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.alpha = 0
        toViewController.detailImageView.isHidden = true
        // Update layout to clean up begnning positions of labels on detail VC, Size Classes issue
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()

        containerView.addSubview(toViewController.view)
        containerView.addSubview(weatherSnapshot)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            // Update layout to set proper target for final frame of animation, Size Classes issue
            toViewController.view.setNeedsLayout()
            toViewController.view.layoutIfNeeded()
            
            toViewController.view.alpha = 1.0
            let newOrigin = CGPoint(x: toViewController.view.frame.origin.x, y: toViewController.view.frame.origin.y + (toViewController.navigationController?.navigationBar.frame.height)!)
            weatherSnapshot.frame.origin = newOrigin

        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: duration, animations: { 
                weatherSnapshot.frame.size = toViewController.view.frame.size
                weatherSnapshot.alpha = 0.0
            }, completion: { (complete) in
                toViewController.detailImageView.isHidden = false
                selectedCell.alpha = 1.0
                weatherSnapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
                fromViewController.tableView.deselectRow(at: selectedRow, animated: true)
            })
        })
    }
    
} // End
