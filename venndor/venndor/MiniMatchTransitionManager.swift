//
//  MiniMatchTransitionManager.swift
//  venndor
//
//  Created by Tynan Davis on 2016-06-16.
//  Copyright © 2016 Venndor. All rights reserved.
//

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var duration = 0.5
    var isPresenting = false
    
    var snapshot:UIView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Get reference to our fromView, toView and the container view
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // Set up the transform for sliding
        let container = transitionContext.containerView()
        let moveDown = CGAffineTransformMakeTranslation(0, -150)
        let moveUp = CGAffineTransformMakeTranslation(0, -50)
        
        // Add both views to the container view
        if isPresenting {
            toView.transform = moveUp
            snapshot = fromView.snapshotViewAfterScreenUpdates(true)
            container!.addSubview(toView)
            container!.addSubview(snapshot!)
        }
        
        // Perform the animation
        UIView.animateWithDuration(0.5, animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView.transform = CGAffineTransformIdentity
            } else {
                self.snapshot?.transform = CGAffineTransformIdentity
                fromView.transform = moveUp
            }
            
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                if !self.isPresenting {
                    self.snapshot?.removeFromSuperview()
                }
        })
        
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
}
