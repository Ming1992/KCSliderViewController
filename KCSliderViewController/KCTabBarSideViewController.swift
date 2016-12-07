//
//  KCTabBarSideViewController.swift
//  KCSliderViewController
//
//  Created by liaozhenming on 2016/12/1.
//  Copyright © 2016年 liaozhenming. All rights reserved.
//

import UIKit

class KCTabBarSideViewController: UITabBarController {

    private var _panner: UIPanGestureRecognizer!
    
    private var _backgroundImageView: UIImageView!
    
    private var _animationDuration: Double = 0.15
    private var _cornerRadius: CGFloat = 25.0
    
    private var _beganPoint: CGPoint!
    private var _resetCenter: CGPoint!
    private var _maxOffsetX: CGFloat!
    
    
    var _selectedView: UIView!{
        didSet{
            _selectedView?.addGestureRecognizer(_panner)
            self.kc_updateSelfSubviews()
        }
    }
    
    var _leftViewController: UIViewController!{
        didSet{
            self.addChildViewController(_leftViewController)
            _leftView = _leftViewController.view
//            self.view.insertSubview(_leftView, aboveSubview: _backgroundImageView)      
            self.view.insertSubview(_leftView, at: 0)
            self.kc_updateSelfSubviews()
        }
    }
    var _leftView: UIView!
    var _leftAnimated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  隐藏底部Bar
        self.tabBar.isHidden = true
        
        let rootView = self.view
        rootView?.backgroundColor = UIColor.white
        
//        _backgroundImageView = UIImageView.init(frame: (rootView?.bounds)!)
//        _backgroundImageView.backgroundColor = UIColor.orange
//        rootView?.insertSubview(_backgroundImageView, at: 0)
        
        _panner = UIPanGestureRecognizer.init(target: self, action: #selector(KCSliderViewController.kc_onPan(_:)))
//        rootView?.addGestureRecognizer(_panner)
        
        _resetCenter = CGPoint(x:(rootView?.bounds.width)!/2.0,y:(rootView?.bounds.height)!/2.0)
        let rootWidth : CGFloat = (rootView?.bounds.width)!
        _maxOffsetX = rootWidth * 0.7
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //  设置当前的可移动视图
        self._selectedView = self.selectedViewController?.view
//        self._selectedView = self.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func kc_onPan(_ panner:UIPanGestureRecognizer){
        
        let point = panner.translation(in: _selectedView)
        
        switch panner.state {
        case .began:
            self._beganPoint = point
            if __CGPointEqualToPoint(_selectedView.center, _resetCenter) {
                //                _leftView.center = CGPoint(x:_resetCenter.x - _maxOffsetX,y:_resetCenter.y)
                //                _rigthView.center = CGPoint(x:_resetCenter.x + _maxOffsetX,y:_resetCenter.y)
            }
            break
        case .changed:
            let offsetX = point.x - self._beganPoint.x
            
            var rootAnimationCenter: CGPoint = _selectedView.center
            rootAnimationCenter.x += offsetX
            
            if rootAnimationCenter.x >= _resetCenter.x && rootAnimationCenter.x <= (_resetCenter.x + _maxOffsetX){
                _selectedView.center = rootAnimationCenter
                
                let proportion : CGFloat = (rootAnimationCenter.x - _resetCenter.x) / _maxOffsetX
                let offsetScale : CGFloat = proportion * 0.2
                _selectedView.transform = CGAffineTransform(scaleX:1.0-offsetScale,y:1.0-offsetScale)
            }
            self._beganPoint = point
            
            break
        case .ended:
            
            let rootAnimationCenter: CGPoint = _selectedView.center
            if rootAnimationCenter.x >= _resetCenter.x + _maxOffsetX * 0.6 {
                self.kc_startAnimating()
            } else {
                self.kc_resetPoint()
            }
            
            break
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private methods
    private func kc_resetPoint(){
        
        UIView.animate(withDuration: _animationDuration, animations: {()->Void in
            
            self._selectedView.center = self._resetCenter
            self._selectedView.transform = CGAffineTransform.identity
            self._selectedView.layer.cornerRadius = 0.0
            
        }, completion: nil)
    }
    
    private func kc_startAnimating(){
        
        UIView.animate(withDuration: _animationDuration, animations: {()->Void in
            
            self._selectedView.center = CGPoint(x:self._resetCenter.x + self._maxOffsetX, y:self._resetCenter.y)
            self._selectedView.transform = CGAffineTransform(scaleX:0.8,y:0.8)
            
            self._selectedView.layer.shadowColor = UIColor.black.cgColor
            self._selectedView.layer.shadowOffset = CGSize(width:-8, height:0);
            self._selectedView.layer.shadowOpacity = 0.15;
            self._selectedView.layer.shadowRadius = 3
            
        }, completion: nil)
    }
    
    private func kc_updateSelfSubviews() {
        
        if (_selectedView != nil) && (_leftView != nil) {
            
            print("_selectedView:")
            print(_selectedView)
            _leftView.removeFromSuperview()
            
            let view = self.view.subviews[0]
            
            print(view.subviews)
            
//            self.view.insertSubview(_leftView, aboveSubview: _selectedView)
//            self.view.addSubview(_leftView)
            self.view.insertSubview(_leftView, at: 1)
            
//            for view in self.view.subviews {
//                
//                if view != _leftView{
//                    view.isHidden = true
//                }
//            }
        }
    }
    
    public func kc_setLefSideViewController(sideViewController: UIViewController, animated:Bool) {
        
        if _leftViewController != nil {
            _leftViewController.removeFromParentViewController()
            _leftViewController.view.removeFromSuperview()
        }
        _leftAnimated = animated
        _leftViewController = sideViewController
        
    }
}
