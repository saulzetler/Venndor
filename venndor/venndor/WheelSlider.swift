//
//  WheelSlider.swift
//  WheelSliderSample
//
//  Created by 曽和修平 on 2015/10/31.
//  Copyright © 2015年 deeptoneworks. All rights reserved.
//

import UIKit

protocol WheelSliderDelegate{
    func updateSliderValue(value:Double,sender:WheelSlider) -> ()
}

public enum WSKnobLineCap{
    case WSLineCapButt
    case WSLineCapRound
    case WSLineCapSquare
    var getLineCapValue:String{
        switch self{
        case .WSLineCapButt:
            return kCALineCapButt
        case .WSLineCapRound:
            return kCALineCapRound
        case .WSLineCapSquare:
            return kCALineCapSquare
        }
    }
}

@IBDesignable
public class WheelSlider: UIView {
    
    var totalTheta: CGFloat = 0

    private let wheelView:UIView
    
    private var beforePoint:Double = 0
    private var currentPoint:Double = 0{
        didSet{
            wheelView.layer.removeAllAnimations()
            wheelView.layer.addAnimation(nextAnimation(), forKey: "rotateAnimation")
            valueTextLayer?.string = "$\(Int(calcCurrentValue()))"
            delegate?.updateSliderValue(calcCurrentValue(),sender: self)
            callback?(calcCurrentValue())
        }
    }
    
    public var beganTouchPosition = CGPointMake(0, 0)
    public var moveTouchPosition = CGPointMake(0, 0){
        didSet{
            calcCurrentPoint()
        }
    }
    private var valueTextLayer:CATextLayer?
    
    var delegate : WheelSliderDelegate?
    public var callback : ((Double) -> ())?
    
    //backgroundCircleParameter
    
    @IBInspectable public var backStrokeColor : UIColor = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
    @IBInspectable public var backFillColor : UIColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    @IBInspectable public var backWidth : CGFloat = 10.0
    
    
    //knobParameter
    @IBInspectable public var knobStrokeColor : UIColor = UIColor.whiteColor()
    @IBInspectable public var knobWidth : CGFloat = 30.0
    @IBInspectable public var knobLength : CGFloat = 0.01
    public var knobLineCap = WSKnobLineCap.WSLineCapRound
    
 
    @IBInspectable public var minVal:Int = 0
    @IBInspectable public var maxVal:Int = 50
    @IBInspectable public var speed:Int = 100
    @IBInspectable public var isLimited:Bool = false
    @IBInspectable public var allowNegativeNumber:Bool = false
    @IBInspectable public var isValueText:Bool = true
    @IBInspectable public var valueTextColor:UIColor = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
    @IBInspectable public var valueTextFontSize:CGFloat = 70.0
    public lazy var font:UIFont = UIFont.systemFontOfSize(self.valueTextFontSize)
    
    override init(frame: CGRect) {
        wheelView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        super.init(frame: frame)
        addSubview(wheelView)
        wheelView.layer.addSublayer(drawBackgroundCicle())
        wheelView.layer.addSublayer(drawPointerCircle())
        if let layer = drawValueText(){
            valueTextLayer = layer
            self.layer.addSublayer(layer)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        wheelView = UIView();
        super.init(coder: aDecoder)
        wheelView.frame = bounds
        addSubview(wheelView)
        wheelView.layer.addSublayer(drawBackgroundCicle())
        wheelView.layer.addSublayer(drawPointerCircle())
        if let layer = drawValueText(){
            valueTextLayer = layer
            self.layer.addSublayer(layer)
        }
    }
    
    private func drawValueText()->CATextLayer?{
        guard(isValueText)else{
            return nil
        }
        let textLayer = CATextLayer()
        textLayer.string = "$\(0)"
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.frame = CGRectMake(0, frame.origin.y/6, bounds.width, bounds.height)
        textLayer.foregroundColor = valueTextColor.CGColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        return textLayer
    }
    
    private func drawBackgroundCicle() -> CAShapeLayer{
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = backStrokeColor.CGColor
        ovalShapeLayer.fillColor = backFillColor.CGColor
        ovalShapeLayer.lineWidth = backWidth
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let start = CGFloat(0)
        let end = CGFloat(2.0 * M_PI)
        ovalShapeLayer.path = UIBezierPath(arcCenter: center, radius: max(bounds.width, bounds.height) / 2, startAngle:start, endAngle: end ,clockwise: true).CGPath
        return ovalShapeLayer
        
    }
    private func drawPointerCircle() -> CAShapeLayer{
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = knobStrokeColor.CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = knobWidth
        ovalShapeLayer.lineCap = knobLineCap.getLineCapValue
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let start = CGFloat(M_PI)
        let end = CGFloat(M_PI) + knobLength

        ovalShapeLayer.path = UIBezierPath(arcCenter: center, radius: max(bounds.width, bounds.height) / 2, startAngle:start, endAngle: end ,clockwise: true).CGPath
        return ovalShapeLayer
    
    }
    
    private func nextAnimation()->CABasicAnimation{

        let start = CGFloat(beforePoint/Double(speed) * M_PI)
        let end = CGFloat(currentPoint/Double(speed) * M_PI)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.duration = 0
        anim.repeatCount = 0
        anim.fromValue = start
        anim.toValue =  end
        anim.removedOnCompletion = false;
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = false
        return anim
    }
    
    private func calcCurrentValue() -> Double{
        
        
        let normalization = Double(maxVal) / Double(speed)
        var val = currentPoint*normalization/2.0
        if(isLimited && val > Double(maxVal)){
            beforePoint = 0
            currentPoint = 0
        }
        if (val < 0 && allowNegativeNumber == false) {
            val = 0
        }
        return val
    }
    
    private func calcCurrentPoint(){
        
        let centerX = bounds.size.width/2.0
        let centerY = bounds.size.height/2.0
        
        let xPosNew = moveTouchPosition.x - centerX
        let yPosNew = moveTouchPosition.y - centerY
        let xPosOld = beganTouchPosition.x - centerX
        let yPosOld = beganTouchPosition.y - centerY
        
//        print("xNew: \(xPosNew)")
//        print("yNew: \(yPosNew)")
//        print("xOld: \(xPosOld)")
//        print("yOld: \(yPosOld)")
        
        
        
        let deltaX = xPosNew - xPosOld
        let deltaY = yPosNew - yPosOld
        
        print("deltaX: \(deltaX)")
        print("deltaY: \(deltaY)")
        
        var dTheta: CGFloat
        
//        if deltaY >= 0 {
//            dTheta = CGFloat(M_PI/2) - atan(deltaY/deltaX)
//        } else {
//            dTheta = CGFloat(M_PI/2) + atan(deltaY/deltaX)
//        }
        
        if deltaX != 0 {
            dTheta = atan(abs(deltaY)/abs(deltaX))
        } else {
            dTheta = 0
        }
        print("Delta: \(dTheta)")

        
        let displacementY = abs(beganTouchPosition.y - moveTouchPosition.y)
        let displacementX = abs(beganTouchPosition.x - moveTouchPosition.x)
//        let distance = Double(sqrt(displacementX + displacementY)*0.8)
        
//        guard(max(displacementX,displacementY) > 1.0)else{
//            return
//        }
        
        if(calcCurrentValue() < 0){
            return
        }
        
        if(displacementX > displacementY){ // moving side to side
            if(centerY > beganTouchPosition.y){ //below center
                if(moveTouchPosition.x >= beganTouchPosition.x){ //moving to right
                    totalTheta = totalTheta + dTheta
                }else{ // moving to left
                    totalTheta = totalTheta - dTheta
                }
            }else{ // above center
                if(moveTouchPosition.x > beganTouchPosition.x){ //moving to right
                    totalTheta = totalTheta + dTheta
                }else{ // moving left
                    totalTheta = totalTheta - dTheta
                }
            }
        }else{ // moving up/down
            if(centerX <= beganTouchPosition.x){ // on the right of center
                if(moveTouchPosition.y >= beganTouchPosition.y){ // moving up
                    totalTheta = totalTheta + dTheta
                }else{ // moving down
                    totalTheta = totalTheta - dTheta
                }
            }else{ // on the left
                if(moveTouchPosition.y > beganTouchPosition.y){ // moving up
                    totalTheta = totalTheta - dTheta
                }else{ // moving down
                    totalTheta = totalTheta + dTheta
                }
            }
        }
        
        print("Total: \(totalTheta)")
        beforePoint = currentPoint
        currentPoint = (Double(totalTheta)*10/(2*M_PI))
        
        
    }
    
//    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first as UITouch?
//        if let t = touch{
//            let pos = t.locationInView(self)
//            print("Touches Moved")
////            print(pos)
//            
//            beganTouchPosition = moveTouchPosition
//            moveTouchPosition = pos
////            print("BTP: \(beganTouchPosition)")
////            print("MTB: \(moveTouchPosition)")
//            
//        }
//    }
 

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override public func drawRect(rect: CGRect) {
//        let h = rect.height
//        let w = rect.width
//        self.backgroundColor = UIColor.clearColor()
//        
//        let color:UIColor = UIColor.clearColor()
//        color.setFill()
//        color.setStroke()
//        color.set()
//        
//        let drect = CGRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
//        let bpath:UIBezierPath = UIBezierPath(rect: drect)
//        
//        bpath.stroke()
//
//    }
}
