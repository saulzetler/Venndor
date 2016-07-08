//
//  DraggableView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
}

public class DraggableView: UIView, UIScrollViewDelegate {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var information: UILabel!
    var xFromCenter: Float!
    var yFromCenter: Float!
    
    //for scroll view
    var scrollView: UIScrollView!
    var containerView = UIView()
    var pageControl: UIPageControl! = UIPageControl()
    var picNum: Int!
    
    //save current item
    var currentItem: Item!
    var firstPhoto: UIImage!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, item: Item) {
        super.init(frame: frame)

        self.setupView()
        currentItem = item
        
        setupScrollView(item)
        

        information = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        information.text = "no info given"
        information.textAlignment = NSTextAlignment.Center
        information.textColor = UIColor.blackColor()

        self.backgroundColor = UIColor.whiteColor()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged(_:)))

        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(information)

        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100))
        overlayView.alpha = 0
        self.addSubview(overlayView)

        xFromCenter = 0
        yFromCenter = 0
    
    }
    
    
    //scroll view funcs
    func setupScrollView(item: Item) {
        
        scrollView = UIScrollView()
        let cardWidth = self.frame.width
        let cardHeight = self.frame.height
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, cardWidth, cardHeight)
        scrollView.contentSize = CGSizeMake(cardWidth, cardHeight*CGFloat(item.photoCount))
        scrollView.decelerationRate = 0.1
        pageControl.currentPage = 0
        containerView.frame = CGRectMake(0, 0, cardWidth, cardHeight*CGFloat(item.photoCount))
        picNum = 0
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        let temp = ItemManager()
        for x in 0..<item.photoCount {
            temp.retrieveItemImageById(item.id, imageIndex: x) { img, error in
                guard error == nil else {
                    print("Error getting the image from the server: \(error)")
                    return
                }
                if x == 0 {
                    self.firstPhoto = img
                }
                
                if let phonto = img {
                    dispatch_async(dispatch_get_main_queue()) {
                        let temp2 = UIImageView(frame: CGRectMake(0, scrollViewHeight*CGFloat(x),scrollViewWidth, scrollViewHeight))
                        temp2.image = phonto
                        self.containerView.addSubview(temp2)
                    }
                }
            }
        }
        scrollView.addSubview(containerView)
        
        self.addSubview(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        print("decel")
        adjustPage()
    }

    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        adjustPage()
    }
    
    func adjustPage() {
        
        // Test the offset and calculate the current page after scrolling ends
        let pageHeight:CGFloat = CGRectGetHeight(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageHeight/2)/pageHeight)+1
        // Change the indicator
        picNum = Int(currentPage)
        self.pageControl.currentPage = picNum

        switch picNum {
        case 0:
            print("pic 1")
        case 1:
            print("pic 2")
        case 2:
            print("pic 3")
        case 3:
            print("pic 4")
        case 4:
            print("pic 5")
        default:
            break
        }
        
        for y in 0...6 {
            if y == picNum {
                let yOffset = CGPointMake(0, pageHeight*CGFloat(y));
                self.scrollView.setContentOffset(yOffset, animated: true)
            }
        }
    }

    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }

    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translationInView(self).x)
        yFromCenter = Float(gestureRecognizer.translationInView(self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            self.originPoint = self.center
        case UIGestureRecognizerState.Changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

//            self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y + CGFloat(yFromCenter))

            self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y)
            
            let transform = CGAffineTransformMakeRotation(CGFloat(rotationAngle))
            let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(CGFloat(xFromCenter))
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.Possible:
            fallthrough
        case UIGestureRecognizerState.Cancelled:
            fallthrough
        case UIGestureRecognizerState.Failed:
            fallthrough
        default:
            break
        }
    }

    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        } else {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.4))
    }

    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        let floatYFromCenter = Float(yFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        }
        else if floatYFromCenter < -ACTION_MARGIN {
            self.upAction()
        }
        else if floatYFromCenter > ACTION_MARGIN {
            self.downAction()
        }
        else {
            resetView()
        }
    }
    
    func resetView() {
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.center = self.originPoint
            self.transform = CGAffineTransformMakeRotation(0)
            self.overlayView.alpha = 0
        })
    }
    
    func upAction() -> Void {
        //use this function to go to next picture
        print("swiped up")
        adjustPage()
        resetView()
    }
    
    func downAction() -> Void {
        //use this function to go to previous picture
        print("swiped down")
        adjustPage()
        resetView()
    }
    
    func rightAction() -> Void {
//        let offerView = OfferView(self.frame = CGRectMake(0, 0, 0, 0))
//        self.parentViewController!.bringUpNewView(offerView)
//        let image: UIImage = currentItem.photos![0]
//        let offerViewController = OfferViewController()
//        offerViewController.setupBackground(firstPhoto)
        
        self.parentViewController!.performSegueWithIdentifier("toOfferScreen", sender: self.parentViewController!)
        
        let finishPoint: CGPoint = CGPointMake(500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        
        
        delegate.cardSwipedRight(self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }

    func rightClickAction() -> Void {
        let finishPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }

    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
}