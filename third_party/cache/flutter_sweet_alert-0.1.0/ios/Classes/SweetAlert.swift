//
//  SweetAlert.swift
//  SweetAlert
//
//  Created by Codester on 11/3/14.
//  Copyright (c) 2014 Codester. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public enum AlertStyle {
    case success,error,warning,loading,none
    case customImage(imageFile:String)
}

open class SweetAlert: UIViewController {
    let kBakcgroundTansperancy: CGFloat = 0.7
    let kHeightMargin: CGFloat = 10.0
    let KTopMargin: CGFloat = 20.0
    let kWidthMargin: CGFloat = 10.0
    let kAnimatedViewHeight: CGFloat = 70.0
    let kMaxHeight: CGFloat = 300.0
    var kContentWidth: CGFloat = 300.0
    let kButtonHeight: CGFloat = 35.0
    var textViewHeight: CGFloat = 90.0
    let kTitleHeight:CGFloat = 30.0
    var type: AlertStyle=AlertStyle.none
    var clickToCancel:Bool=false
    var autoCloseTime:Double=0.0
    var strongSelf:SweetAlert?
    var contentView = UIView()
    var titleLabel: UILabel = UILabel()
    var buttons: [UIButton] = []
    var animatedView: AnimatableView?
    var imageView:UIImageView?
    var closeOnCancel:Bool=true
    var closeOnConfirm:Bool=true
    var contentTextView = UITextView()
    var userAction:((_ buttonIndex: Int) -> Void)? = nil
    let kFont = "Helvetica"
    
    init(alertType:AlertStyle) {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:kBakcgroundTansperancy)
        self.view.addSubview(contentView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SweetAlert.tapGesture(sender:))))
        self.type=alertType
        
        self.setupContentView()
        self.setupTitleLabel()
        self.setupcontentTextView()
        //Retaining itself strongly so can exist without strong refrence
        strongSelf = self
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        self.closeAlert(-1)
    }
    fileprivate func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentTextView)
        contentView.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        contentView.layer.borderColor = UIColor.colorFromRGB(0xCCCCCC).cgColor
        view.addSubview(contentView)
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: kFont, size:25)
        titleLabel.textColor = UIColor.colorFromRGB(0x575757)
    }
    
    fileprivate func setupcontentTextView() {
        contentTextView.text = ""
        contentTextView.textAlignment = .center
        contentTextView.font = UIFont(name: kFont, size:16)
        contentTextView.textColor = UIColor.colorFromRGB(0x797979)
        contentTextView.isEditable = false
    }
    
    fileprivate func resizeAndRelayout() {
        let mainScreenBounds = UIScreen.main.bounds
        self.view.frame.size = mainScreenBounds.size
        let x: CGFloat = kWidthMargin
        var y: CGFloat = KTopMargin
        let width: CGFloat = kContentWidth - (kWidthMargin*2)
        
        if animatedView != nil {
            animatedView!.frame = CGRect(x: (kContentWidth - kAnimatedViewHeight) / 2.0, y: y, width: kAnimatedViewHeight, height: kAnimatedViewHeight)
            contentView.addSubview(animatedView!)
            y += kAnimatedViewHeight + kHeightMargin
        }
        
        if imageView != nil {
            imageView!.frame = CGRect(x: (kContentWidth - kAnimatedViewHeight) / 2.0, y: y, width: kAnimatedViewHeight, height: kAnimatedViewHeight)
            contentView.addSubview(imageView!)
            y += imageView!.frame.size.height + kHeightMargin
        }
        
        // Title
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        // Subtitle
        if self.contentTextView.text.isEmpty == false {
            let subtitleString = contentTextView.text! as NSString
            let rect = subtitleString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:contentTextView.font!], context: nil)
            textViewHeight = ceil(rect.size.height) + 10.0
            contentTextView.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
            contentView.addSubview(contentTextView)
            y += textViewHeight + kHeightMargin
        }
        if(buttons.count>0){
            var buttonRect:[CGRect] = []
            for button in buttons {
                let string = button.title(for: UIControlState())! as NSString
                buttonRect.append(string.boundingRect(with: CGSize(width: width, height:0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSAttributedStringKey.font:button.titleLabel!.font], context:nil))
            }
            
            var totalWidth: CGFloat = 0.0
            if buttons.count == 2 {
                totalWidth = buttonRect[0].size.width + buttonRect[1].size.width + kWidthMargin + 40.0
            }
            else{
                totalWidth = buttonRect[0].size.width + 20.0
            }
            y += kHeightMargin
            var buttonX = (kContentWidth - totalWidth ) / 2.0
            for i in 0 ..< buttons.count {
                
                buttons[i].frame = CGRect(x: buttonX, y: y, width: buttonRect[i].size.width + 20.0, height: buttonRect[i].size.height + 10.0)
                buttonX = buttons[i].frame.origin.x + kWidthMargin + buttonRect[i].size.width + 20.0
                buttons[i].layer.cornerRadius = 5.0
                self.contentView.addSubview(buttons[i])
                buttons[i].addTarget(self, action: #selector(SweetAlert.pressed(_:)), for: UIControlEvents.touchUpInside)
                
            }
            y += kHeightMargin + buttonRect[0].size.height + 10.0
            if y > kMaxHeight {
                let diff = y - kMaxHeight
                let sFrame = contentTextView.frame
                contentTextView.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
                
                for button in buttons {
                    let bFrame = button.frame
                    button.frame = CGRect(x: bFrame.origin.x, y: bFrame.origin.y - diff, width: bFrame.width, height: bFrame.height)
                }
                
                y = kMaxHeight
            }
        }
        
        
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - kContentWidth) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: kContentWidth, height: y)
        contentView.clipsToBounds = true
    }
    
    @objc open func pressed(_ sender: UIButton!) {
        self.closeAlert(sender.tag)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var sz = UIScreen.main.bounds.size
        let sver = UIDevice.current.systemVersion as NSString
        let ver = sver.floatValue
        if ver < 8.0 {
            // iOS versions before 7.0 did not switch the width and height on device roration
            if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
                let ssz = sz
                sz = CGSize(width:ssz.height, height:ssz.width)
            }
        }
        self.resizeAndRelayout()
    }
    func setAlertType(_ type:AlertStyle) -> SweetAlert {
        self.type=type
        return self
    }
    func closeAlert(_ buttonIndex:Int){
        if userAction !=  nil {
            SweetAlertContext.shouldNotAnimate = false
            userAction!(buttonIndex)
        }
        if(buttonIndex == -1 && !self.clickToCancel){
            return;
        }
        view.alpha = 1.0;
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.alpha = 0.0;
        })
        
        let previousTransform = self.contentView.transform
        self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.contentView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
        }, completion: { (Bool) -> Void in
            self.contentView.transform = previousTransform
            self.view.removeFromSuperview()
            self.cleanUpAlert()
            
            //Releasing strong refrence of itself.
            self.strongSelf = nil
            
        })
    }
    
    func cleanUpAlert() {
        
        if self.animatedView != nil {
            self.animatedView!.removeFromSuperview()
            self.animatedView = nil
        }
        self.contentView.removeFromSuperview()
        self.contentView = UIView()
    }
    open func setTitleText(_ title:String) ->SweetAlert{
        self.titleLabel.text = title
        return self
    }
    open func setContentText(_ content:String) ->SweetAlert{
        self.contentTextView.text=content
        return self
    }
    open func setAutoClose(_ delay:Double) ->SweetAlert{
        self.autoCloseTime=delay
        return self
    }
    open func setCancelButton(_ isShow:Bool,_ text:String) ->SweetAlert{
        if(isShow){
            if text.isEmpty == false {
                let button: UIButton = UIButton(type: UIButtonType.custom)
                button.setTitle(text, for: UIControlState())
                button.backgroundColor = UIColor.colorFromRGB(0xdd6b55)
                button.isUserInteractionEnabled = true
                button.tag = 0
                buttons.append(button)
            }
        }
        return self
    }
    open func setConfirmButton(_ text:String) ->SweetAlert{
        if text.isEmpty == false {
            let button: UIButton = UIButton(type: UIButtonType.custom)
            button.setTitle(text, for: UIControlState())
            button.backgroundColor = UIColor.colorFromRGB(0x6bd505)
            button.isUserInteractionEnabled = true
            button.tag = 1
            buttons.append(button)
        }
        return self
    }
    open func setCancelable(_ cancelable:Bool)->SweetAlert{
        self.clickToCancel=cancelable
        return self
    }
    open func setCloseOnCancelClick(_ closeOnCancel:Bool)->SweetAlert{
        self.closeOnCancel=closeOnCancel
        return self
    }
    open func setCloseOnConfirmClick(_ closeOnConfirm:Bool)->SweetAlert{
        self.closeOnConfirm=closeOnConfirm
        return self
    }
    open func update(action: ((_ buttonIndex: Int) -> Void)? = nil)->SweetAlert{
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        userAction=action
        switch type {
        case .success:
            self.animatedView = SuccessAnimatedView()
            
        case .error:
            self.animatedView = CancelAnimatedView()
            
        case .warning:
            self.animatedView = InfoAnimatedView()
        case .loading:
            self.animatedView = LoadingAnimatedView()
        case let .customImage(imageFile):
            if let image = UIImage(named: imageFile) {
                self.imageView = UIImageView(image: image)
            }
        case .none:
            self.animatedView = nil
        }
        resizeAndRelayout()
        if self.animatedView != nil {
            self.animatedView!.animate()
        }
        if(self.autoCloseTime>0){
            let time: TimeInterval = self.autoCloseTime
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.closeAlert(-2)
            }
        }
        return self
    }
    open func show(action: ((_ buttonIndex: Int) -> Void)? = nil) ->SweetAlert{
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        userAction=action
        switch type {
        case .success:
            self.animatedView = SuccessAnimatedView()
            
        case .error:
            self.animatedView = CancelAnimatedView()
            
        case .warning:
            self.animatedView = InfoAnimatedView()
        case .loading:
            self.animatedView = LoadingAnimatedView()
        case let .customImage(imageFile):
            if let image = UIImage(named: imageFile) {
                self.imageView = UIImageView(image: image)
            }
        case .none:
            self.animatedView = nil
        }
        resizeAndRelayout()
        if SweetAlertContext.shouldNotAnimate == true {
            //Do not animate Alert
            if self.animatedView != nil {
                self.animatedView!.animate()
            }
        }
        else {
            animateAlert()
        }
        if(self.autoCloseTime>0){
            let time: TimeInterval = self.autoCloseTime
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.closeAlert(-2)
            }
        }
        return self
        
    }
    
    
    func animateAlert() {
        
        view.alpha = 0;
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.alpha = 1.0;
        })
        
        let previousTransform = self.contentView.transform
        self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.contentView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0.0);
        }, completion: { (Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0);
                    if self.animatedView != nil {
                        self.animatedView!.animate()
                    }
                    
                }, completion: { (Bool) -> Void in
                    
                    self.contentView.transform = previousTransform
                })
            })
        })
    }
    
    fileprivate struct SweetAlertContext {
        static var shouldNotAnimate = false
    }
}

// MARK: -

// MARK: Animatable Views

class AnimatableView: UIView {
    func animate(){
        print("Should overide by subclasss", terminator: "")
    }
}

class CancelAnimatedView: AnimatableView {
    
    var circleLayer = CAShapeLayer()
    var crossPathLayer = CAShapeLayer()
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * Double.pi / 180.0), 1, 0, 0);
        circleLayer.transform = t
        crossPathLayer.opacity = 0.0
    }
    
    override func layoutSubviews() {
        setupLayers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var outlineCircle: CGPath  {
        let path = UIBezierPath()
        let startAngle: CGFloat = CGFloat((0) / 180.0 * Double.pi)  //0
        let endAngle: CGFloat = CGFloat((360) / 180.0 * Double.pi)   //360
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.width/2.0), radius: self.frame.size.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        return path.cgPath
    }
    
    fileprivate var crossPath: CGPath  {
        let path = UIBezierPath()
        let factor:CGFloat = self.frame.size.width / 5.0
        path.move(to: CGPoint(x: self.frame.size.height/2.0-factor,y: self.frame.size.height/2.0-factor))
        path.addLine(to: CGPoint(x: self.frame.size.height/2.0+factor,y: self.frame.size.height/2.0+factor))
        path.move(to: CGPoint(x: self.frame.size.height/2.0+factor,y: self.frame.size.height/2.0-factor))
        path.addLine(to: CGPoint(x: self.frame.size.height/2.0-factor,y: self.frame.size.height/2.0+factor))
        
        return path.cgPath
    }
    
    fileprivate func setupLayers() {
        circleLayer.path = outlineCircle
        circleLayer.fillColor = UIColor.clear.cgColor;
        circleLayer.strokeColor = UIColor.colorFromRGB(0xF27474).cgColor;
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4;
        circleLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        circleLayer.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        self.layer.addSublayer(circleLayer)
        
        crossPathLayer.path = crossPath
        crossPathLayer.fillColor = UIColor.clear.cgColor;
        crossPathLayer.strokeColor = UIColor.colorFromRGB(0xF27474).cgColor;
        crossPathLayer.lineCap = kCALineCapRound
        crossPathLayer.lineWidth = 4;
        crossPathLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        crossPathLayer.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        self.layer.addSublayer(crossPathLayer)
        
    }
    
    override func animate() {
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * Double.pi / 180.0), 1, 0, 0);
        
        var t2 = CATransform3DIdentity;
        t2.m34 = 1.0 / -500.0;
        t2 = CATransform3DRotate(t2, CGFloat(-Double.pi), 1, 0, 0);
        
        let animation = CABasicAnimation(keyPath: "transform")
        let time = 0.3
        animation.duration = time;
        animation.fromValue = NSValue(caTransform3D: t)
        animation.toValue = NSValue(caTransform3D:t2)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.circleLayer.add(animation, forKey: "transform")
        
        
        var scale = CATransform3DIdentity;
        scale = CATransform3DScale(scale, 0.3, 0.3, 0)
        
        
        let crossAnimation = CABasicAnimation(keyPath: "transform")
        crossAnimation.duration = 0.3;
        crossAnimation.beginTime = CACurrentMediaTime() + time
        crossAnimation.fromValue = NSValue(caTransform3D: scale)
        crossAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.8, 0.7, 2.0)
        crossAnimation.toValue = NSValue(caTransform3D:CATransform3DIdentity)
        self.crossPathLayer.add(crossAnimation, forKey: "scale")
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration = 0.3;
        fadeInAnimation.beginTime = CACurrentMediaTime() + time
        fadeInAnimation.fromValue = 0.3
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.fillMode = kCAFillModeForwards
        self.crossPathLayer.add(fadeInAnimation, forKey: "opacity")
    }
    
}

class InfoAnimatedView: AnimatableView {
    
    var circleLayer = CAShapeLayer()
    var crossPathLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    override func layoutSubviews() {
        setupLayers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var outlineCircle: CGPath  {
        let path = UIBezierPath()
        let startAngle: CGFloat = CGFloat((0) / 180.0 * Double.pi)  //0
        let endAngle: CGFloat = CGFloat((360) / 180.0 * Double.pi)   //360
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.width/2.0), radius: self.frame.size.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        let factor:CGFloat = self.frame.size.width / 1.5
        path.move(to: CGPoint(x: self.frame.size.width/2.0 , y: 15.0))
        path.addLine(to: CGPoint(x: self.frame.size.width/2.0,y: factor))
        path.move(to: CGPoint(x: self.frame.size.width/2.0,y: factor + 10.0))
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0,y: factor + 10.0), radius: 1.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        return path.cgPath
    }
    
    func setupLayers() {
        circleLayer.path = outlineCircle
        circleLayer.fillColor = UIColor.clear.cgColor;
        circleLayer.strokeColor = UIColor.colorFromRGB(0xF8D486).cgColor;
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4;
        circleLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        circleLayer.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        self.layer.addSublayer(circleLayer)
    }
    
    override func animate() {
        
        let colorAnimation = CABasicAnimation(keyPath:"strokeColor")
        colorAnimation.duration = 1.0;
        colorAnimation.repeatCount = HUGE
        colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        colorAnimation.autoreverses = true
        colorAnimation.fromValue = UIColor.colorFromRGB(0xF7D58B).cgColor
        colorAnimation.toValue = UIColor.colorFromRGB(0xF2A665).cgColor
        circleLayer.add(colorAnimation, forKey: "strokeColor")
    }
}


class SuccessAnimatedView: AnimatableView {
    
    var circleLayer = CAShapeLayer()
    var outlineLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        circleLayer.strokeStart = 0.0
        circleLayer.strokeEnd = 0.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupLayers()
    }
    
    
    var outlineCircle: CGPath {
        let path = UIBezierPath()
        let startAngle: CGFloat = CGFloat((0) / 180.0 * Double.pi)  //0
        let endAngle: CGFloat = CGFloat((360) / 180.0 * Double.pi)   //360
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0), radius: self.frame.size.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path.cgPath
    }
    
    var path: CGPath {
        let path = UIBezierPath()
        let startAngle:CGFloat = CGFloat((60) / 180.0 * Double.pi) //60
        let endAngle:CGFloat = CGFloat((200) / 180.0 * Double.pi)  //190
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0), radius: self.frame.size.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: 36.0 - 10.0 ,y: 60.0 - 10.0))
        path.addLine(to: CGPoint(x: 85.0 - 20.0, y: 30.0 - 20.0))
        return path.cgPath
    }
    
    
    func setupLayers() {
        
        outlineLayer.position = CGPoint(x: 0,
                                        y: 0);
        outlineLayer.path = outlineCircle
        outlineLayer.fillColor = UIColor.clear.cgColor;
        outlineLayer.strokeColor = UIColor(red: 150.0/255.0, green: 216.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor;
        outlineLayer.lineCap = kCALineCapRound
        outlineLayer.lineWidth = 4;
        outlineLayer.opacity = 0.1
        self.layer.addSublayer(outlineLayer)
        
        circleLayer.position = CGPoint(x: 0,
                                       y: 0);
        circleLayer.path = path
        circleLayer.fillColor = UIColor.clear.cgColor;
        circleLayer.strokeColor = UIColor(red: 150.0/255.0, green: 216.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor;
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 4;
        circleLayer.actions = [
            "strokeStart": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull()
        ]
        self.layer.addSublayer(circleLayer)
    }
    
    override func animate() {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        let factor = 0.045
        strokeEnd.fromValue = 0.00
        strokeEnd.toValue = 0.93
        strokeEnd.duration = 10.0*factor
        let timing = CAMediaTimingFunction(controlPoints: 0.3, 0.6, 0.8, 1.2)
        strokeEnd.timingFunction = timing
        
        strokeStart.fromValue = 0.0
        strokeStart.toValue = 0.68
        strokeStart.duration =  7.0*factor
        strokeStart.beginTime =  CACurrentMediaTime() + 3.0*factor
        strokeStart.fillMode = kCAFillModeBackwards
        strokeStart.timingFunction = timing
        circleLayer.strokeStart = 0.68
        circleLayer.strokeEnd = 0.93
        self.circleLayer.add(strokeEnd, forKey: "strokeEnd")
        self.circleLayer.add(strokeStart, forKey: "strokeStart")
    }
    
}
class LoadingAnimatedView: AnimatableView {
    
    var circleLayer = CAShapeLayer()
    var outlineLayer = CAShapeLayer()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var lineWidth: Int = 4  //线的宽度  默认为2
    
    public var lineColor: UIColor = UIColor(red: 150.0/255.0, green: 216.0/255.0, blue: 115.0/255.0, alpha: 1.0);//线的颜色
    
    fileprivate var timer: Timer?
    
    fileprivate var originStart: CGFloat = CGFloat(Double.pi / 2 * 3)  //开始位置
    
    fileprivate var originEnd: CGFloat = CGFloat(Double.pi / 2 * 3 )   //结束位置  都是顶部
    
    fileprivate var isDraw: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(LoadingAnimatedView.updateLoading), userInfo: nil, repeats: true)  //创建计时器
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)//计时器需要加入到RunLoop中：RunLoop的目的是让你的线程在有工作的时候忙碌，没有工作的时候休眠
        self.timer?.fire()
        
    }
    
    @objc func updateLoading () {
        if (self.originEnd == CGFloat(Double.pi / 2 * 3) && isDraw) {//从无到有的过程
            self.originStart += CGFloat(Double.pi / 10)
            if (self.originStart == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi)) {
                self.isDraw = false
                self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
                return
            }
        }
        
        if (self.originStart == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi) && !self.isDraw) { //从有到无
            self.originEnd += CGFloat(Double.pi / 10)
            if (self.originEnd == CGFloat(Double.pi / 2 * 3 + 2 * Double.pi)) {
                self.isDraw = true
                self.originStart = CGFloat(Double.pi / 2 * 3)
                self.originEnd = CGFloat(Double.pi / 2 * 3)
                self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
                return
            }
        }
        self.setNeedsDisplay() //调用 draw(_ rect: CGRect) 方法
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext() //获取上下文
        let center: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2) // 确定圆心
        let radius = min(self.frame.size.width, self.frame.size.height) / 2 - CGFloat(self.lineWidth); //半径
        let path: UIBezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: self.originStart, endAngle: self.originEnd, clockwise: false) //弧的路径
        context?.addPath(path.cgPath) //将路径、宽度、颜色添加到上下文
        context?.setLineWidth(CGFloat(self.lineWidth)) //
        context?.setStrokeColor(self.lineColor.cgColor) //
        context?.strokePath() //显示弧
    }
    
}
extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

