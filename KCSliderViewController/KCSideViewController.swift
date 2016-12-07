//
//  KCSliderViewController.swift
//  KCSliderViewController
//
//  Created by liaozhenming on 2016/11/30.
//  Copyright © 2016年 liaozhenming. All rights reserved.
//

import UIKit

enum KCSideDirectionType : Int {
    case none
    case left
    case right
}

//  此ViewController 只作为容器使用
class KCSideViewController: UIViewController {
    
    private var directionType: KCSideDirectionType = .none  /**<默认当前无滑动方向*/
    private var sideIsOpen = false              /**<侧边栏是否展开*/
    private var leftEnable = false              /**<是否有左边栏*/
    private var rightEnable = false             /**<是否有右边栏*/
    
    private var animationDuration: Double = 0.15        /**<默认动画执行时间 0.15秒*/
    private var cornerRadius: CGFloat = 25.0            /**<默认最大的圆弧角度*/
    
    /**<是否允许有圆弧 [与阴影二者只能选择其一]*/
    var cornerRadiusEnable = false{
        didSet{
            if (rootView != nil && cornerRadiusEnable) {
                rootView.layer.masksToBounds = true
                shadowEnable = false
                rootView.layer.shadowColor = UIColor.clear.cgColor
                rootView.layer.shadowOpacity = 0.0;
                rootView.layer.shadowRadius = 0.0
            }
        }
    }
    /**<是否允许有阴影 [与圆角二者只能选择其一]*/
    var shadowEnable = false{
        didSet{
            if (rootView != nil && shadowEnable) {
                rootView.layer.masksToBounds = false
                cornerRadiusEnable = false
                rootView.layer.shadowColor = UIColor.black.cgColor
                rootView.layer.shadowOpacity = 0.18;
                rootView.layer.shadowRadius = 5
            }
        }
    }
    
    /**<默认是启用侧边栏*/
    var sideEnable = true
    
    private var beganPoint: CGPoint!                    /**<滑动的开始点*/
    private var resetCenter: CGPoint!                   /**<初始化中心点*/
    private var maxOffsetX: CGFloat!                    /**<最大偏移值 默认为屏幕宽度的70%*/
    
    var backgroundImageView: UIImageView!               /**<背景图片*/
    
    //  根视图控制器
    var rootViewController: UIViewController?
    var rootView: UIView!
    //  左边视图
    var leftViewController: UIViewController?
    var leftView: UIView?
    var leftViewCenter: CGPoint!                        /**<左侧视图初始化位置*/
    //  右边视图
    var rigthViewController: UIViewController?
    var rigthView: UIView?
    var rigthViewCenter: CGPoint!                       /**<右侧视图初始化位置*/
    //  遮罩层
    var shadeView: UIView?
    
    
    //  MARK: 容器视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView = self.view
        backgroundImageView = UIImageView.init(frame: CGRect(x:0,y:0,width:(rootView?.bounds.width)!,height:(rootView?.bounds.height)!))
        rootView?.addSubview(backgroundImageView)
        
        resetCenter = CGPoint(x:(rootView?.bounds.width)!/2.0,y:(rootView?.bounds.height)!/2.0)
        let rootWidth : CGFloat = (rootView?.bounds.width)!
        maxOffsetX = rootWidth * 0.7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public
    static func kc_viewControllerWithViewControllers(rootViewController:UIViewController?,leftViewController:UIViewController?,rightViewController:UIViewController?)->KCSideViewController {
        
        return self.kc_initWithViewControllers(rootViewController: rootViewController,leftViewController: leftViewController,rightViewController:rightViewController)
    }

    static func kc_initWithViewControllers(rootViewController:UIViewController?,leftViewController:UIViewController?,rightViewController:UIViewController?) -> KCSideViewController {
        
        let sliderViewController = KCSideViewController()
        sliderViewController.kc_setViewControllers(rootViewController: rootViewController, leftViewController: leftViewController, rightViewController: rightViewController)
        return sliderViewController
    }
    
    open func kc_setViewControllers(rootViewController:UIViewController?,leftViewController:UIViewController?,rightViewController:UIViewController?) -> Void {
        self.rootViewController = rootViewController
        self.leftViewController = leftViewController
        self.rigthViewController = rightViewController
        
        self.kc_initViewControllersUI()
    }
    
    open func kc_closeSide(animate:Bool){
        //  关闭侧边栏
        if sideIsOpen {
            self.kc_resetPoint(animate: animate)
        }
    }
    
    open func kc_openLeftSide(){
        //  展开左边侧边栏
        if sideIsOpen == false && self.leftViewController != nil{
            self.directionType = .left
            self.kc_startAnimating()
        }
    }
    
    open func kc_openRightSide(){
        //  展开侧边栏
        if sideIsOpen == false && self.rigthViewController != nil{
            self.directionType = .right
            self.kc_startAnimating()
        }
    }
    
    // MARK: - Private
    private func kc_initViewControllersUI() -> Void {
        
        if (rootViewController != nil) {
            self.addChildViewController(rootViewController!)
            self.rootView = rootViewController?.view;
            self.rootView.frame = self.view.bounds
            self.view.addSubview(rootView)
        }
        
        if (leftViewController != nil) {
            self.addChildViewController(leftViewController!)
            self.leftView = leftViewController?.view;
            self.leftView?.frame = self.view.bounds
            self.leftViewCenter = CGPoint(x:(leftView?.bounds.width)!/2.0,y:(leftView?.bounds.height)!/2.0)
            self.view.insertSubview(leftView!, at: 0)
            self.leftEnable = true;
        }
        
        if (rigthViewController != nil) {
            self.addChildViewController(rigthViewController!)
            self.rigthView = rigthViewController?.view;
            self.rigthView?.frame = self.view.bounds
            self.rigthViewCenter = CGPoint(x:(rigthView?.bounds.width)!/2.0,y:(rigthView?.bounds.height)!/2.0)
            self.view.insertSubview(rigthView!, at: 0)
            self.rightEnable = true;
        }
        
        if leftViewController != nil || rigthViewController != nil {
            shadeView = UIView.init(frame: self.view.bounds)
            shadeView?.isHidden = true
            self.view.addSubview(shadeView!)
            
            let panner = UIPanGestureRecognizer.init(target: self, action: #selector(KCSideViewController.kc_onPan(_:)))
            self.view?.addGestureRecognizer(panner)
            
            let tapper = UITapGestureRecognizer.init(target: self, action: #selector(KCSideViewController.kc_onTap(_:)))
            shadeView?.addGestureRecognizer(tapper)
        }
    }
    
    private func kc_resetPoint(animate:Bool){
        
        self.shadeView?.isHidden = true
        self.directionType = .none
        if animate {
            UIView.animate(withDuration: animationDuration, animations: {()->Void in
                self.rootView.center = self.resetCenter
                self.rootView.transform = CGAffineTransform.identity
                self.rootView.layer.cornerRadius = 0.0
                self.shadeView?.center = self.resetCenter
            }, completion:{(finished: Bool) -> Void in
                self.sideIsOpen = false
            })
        }
        else {
            self.rootView.center = self.resetCenter
            self.rootView.transform = CGAffineTransform.identity
            self.rootView.layer.cornerRadius = 0.0
            self.sideIsOpen = false
            self.shadeView?.center = self.resetCenter
        }
    }
    
    private func kc_startAnimating(){
        
        UIView.animate(withDuration: animationDuration, animations: {()->Void in
            
            if (self.directionType == .left) {
                self.rootView.center = CGPoint(x:self.resetCenter.x + self.maxOffsetX, y:self.resetCenter.y)
            }
            else if (self.directionType == .right) {
                self.rootView.center = CGPoint(x:self.resetCenter.x - self.maxOffsetX, y:self.resetCenter.y)
            }
            self.rootView.transform = CGAffineTransform(scaleX:0.8,y:0.8)
            self.shadeView?.center = self.rootView.center
            self.shadeView?.transform = self.rootView.transform
        }, completion: {(finished: Bool) -> Void in
            self.sideIsOpen = true
            self.shadeView?.isHidden = false
        })
    }
    
    // MARK: - 手势
    func kc_onTap(_ tapper:UITapGestureRecognizer) {
        
        self.kc_closeSide(animate: true)
    }
    
    func kc_onPan(_ panner:UIPanGestureRecognizer){
        
        let point = panner.translation(in: self.view)
        
        switch panner.state {
        case .began:
            self.beganPoint = point
            if __CGPointEqualToPoint(rootView.center, resetCenter) {
//                leftView.center = CGPoint(x:_resetCenter.x - maxOffsetX,y:_resetCenter.y)
//                rigthView.center = CGPoint(x:_resetCenter.x + maxOffsetX,y:_resetCenter.y)
            }
            break
        case .changed:
            let offsetX = point.x - self.beganPoint.x
            
            //  判断滑动方向来决定 显示左右边的侧栏
            if directionType == .none {
                if (self.leftEnable && (offsetX > 0)) {
                    directionType = .left
                    if self.shadowEnable {
                        self.rootView.layer.shadowOffset = CGSize(width:-12, height:0);
                    }
                    leftView?.isHidden = false;
                    rigthView?.isHidden = true
                }
                else if (self.rightEnable && offsetX < 0) {
                    directionType = .right
                    if self.shadowEnable {
                        self.rootView.layer.shadowOffset = CGSize(width:12, height:0);
                    }
                    rigthView?.isHidden = false;
                    leftView?.isHidden = true
                }
                else {
                    directionType = .none
                }
            }
            
            var rootAnimationCenter: CGPoint = rootView.center
            rootAnimationCenter.x += offsetX
            
            //  偏移位置与总偏移量的比值
            var proportion: CGFloat = 0.0
            
            if directionType == .left {
                if rootAnimationCenter.x >= resetCenter.x && rootAnimationCenter.x <= (resetCenter.x + maxOffsetX){
                    rootView.center = rootAnimationCenter
                    proportion = (rootAnimationCenter.x - resetCenter.x) / maxOffsetX
                }
            }
            else if directionType == .right{
                if rootAnimationCenter.x <= resetCenter.x && rootAnimationCenter.x >= (resetCenter.x - maxOffsetX){
                    rootView.center = rootAnimationCenter
                    proportion = (resetCenter.x - rootAnimationCenter.x) / maxOffsetX
                }
            }
            
            if proportion != 0.0 {
                let offsetScale : CGFloat = proportion * 0.2
                rootView.transform = CGAffineTransform(scaleX:1.0-offsetScale,y:1.0-offsetScale)
                if cornerRadiusEnable {
                    let radius = proportion * self.cornerRadius
                    rootView.layer.cornerRadius = radius
                }
                shadeView?.center = rootView.center
                shadeView?.transform = rootView.transform
            }

            self.beganPoint = point
            
            break
        case .ended:
            
            let rootAnimationCenter: CGPoint = rootView.center
            
            if directionType == .left {
                if rootAnimationCenter.x >= resetCenter.x + maxOffsetX * 0.6 {
                    self.kc_startAnimating()
                } else {
                    self.kc_resetPoint(animate: true)
                }
            }
            else if directionType == .right{
                if rootAnimationCenter.x <= resetCenter.x - maxOffsetX * 0.6 {
                    self.kc_startAnimating()
                } else {
                    self.kc_resetPoint(animate: true)
                }
            }
            
            break
        default:
            break
        }
    }
}

//  UIViewController侧边栏的分类
extension UIViewController {
    
    /**<关闭侧边栏*/
    open func kc_closeSideViewController(animate:Bool){
        
        var superVC: UIViewController? = self.parent!
        while superVC != nil {
            if (superVC?.isKind(of: KCSideViewController.self))! {
                
                let sideViewController = superVC as! KCSideViewController
                sideViewController.kc_closeSide(animate: animate)
                return
            }
            else {
                superVC = superVC?.parent!
            }
        }
    }
    
    /**<开启侧边栏*/
    open func kc_openSideViewController(left:Bool){
        
        var superVC: UIViewController? = self.parent!
        while superVC != nil {
            if (superVC?.isKind(of: KCSideViewController.self))! {
                
                let sideViewController = superVC as! KCSideViewController
                
                if left {
                    sideViewController.kc_openLeftSide()
                }
                else {
                    sideViewController.kc_openRightSide()
                }
                return
            }
            else {
                superVC = superVC?.parent!
            }
        }
    }
    
    /**<设置是否启用侧边栏*/
    open func kc_sideEnable(enable:Bool){
        var superVC: UIViewController? = self.parent!
        while superVC != nil {
            if (superVC?.isKind(of: KCSideViewController.self))! {
                
                let sideViewController = superVC as! KCSideViewController
                sideViewController.sideEnable = enable
                return
            }
            else {
                superVC = superVC?.parent!
            }
        }
    }
}
