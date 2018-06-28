//
//  BMSAlertView.swift
//  HelloPush
//
//  Created by Anantha Krishnan K G on 28/06/18.
//  Copyright © 2018 Ananth. All rights reserved.
//

import Foundation
import UIKit

class BMSPushModal: UIView {
    
    let backgroundBlurView : UIView = {
        let blurView = UIView()
        blurView.alpha = 0.6
        blurView.backgroundColor = UIColor.black
        return blurView
    }()
    
    let messageView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
        
    }()
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        let fontDescriptor = UIFontDescriptor()
        label.font = UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 20)
        return label
    }()
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    convenience init(title:String, message:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, message: message)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(title:String, message:String){
        
        
        
        backgroundBlurView.frame = frame
        backgroundBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundBlurView)
        
        
        let dialogViewWidth = frame.width-64
        titleLabel.frame = CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30)
        titleLabel.text = title
        messageView.addSubview(titleLabel)
        
        
        dividerView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        dividerView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        messageView.addSubview(dividerView)
        
        
        let rect = NSString(string: message).boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
        messageLabel.frame.origin = CGPoint(x: 8, y: dividerView.frame.height + dividerView.frame.origin.y + 8)
        messageLabel.frame.size = CGSize(width: dialogViewWidth - 16 , height: rect.height + 10)
        messageLabel.text = message
        messageView.addSubview(messageLabel)
        
        let dialogViewHeight = titleLabel.frame.height + dividerView.frame.height + messageLabel.frame.height + 30
        
        messageView.frame.origin = CGPoint(x: 32, y: frame.height)
        messageView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        addSubview(messageView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    func show(animated:Bool){
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(self)
        }
        
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.messageView.center  = self.center
        }, completion: { (completed) in
            
        })
    }
    
    
    func dismiss(animated: Bool) {
        
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.messageView.center = CGPoint(x: self.center.x, y: self.frame.height + self.messageView.frame.height/2)
        }, completion: { (completed) in
            self.removeFromSuperview()
        })
    }
}
