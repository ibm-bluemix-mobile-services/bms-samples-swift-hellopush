//
//  ViewController.swift
//  HelloPush
//
//  Created by Anantha Krishnan K G on 28/06/18.
//  Copyright © 2018 Ananth. All rights reserved.
//

import UIKit

public class PushViewController: UIViewController {

    let responseLabel:UILabel = {
        var label = UILabel()
        label.text = "Welcome to IBM Cloud Push Notifictions"
        let fontDescriptor = UIFontDescriptor()
        label.font = UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let pushLabel:UILabel = {
        let label = UILabel()
        label.text = "Enable Push Notifications"
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
    }()
    
    let pushSwitch: UISwitch = {
        
        let pushSwitch = UISwitch()
        pushSwitch.isOn = false
        pushSwitch.onTintColor = UIColor.green
        pushSwitch.onTintColor = UIColor.blue
        pushSwitch.tintColor = UIColor.red
        pushSwitch.translatesAutoresizingMaskIntoConstraints = false
        return pushSwitch
    }()
    
    let pushStackView: UIStackView = {
        let pushStackView = UIStackView()
        pushStackView.distribution = .equalSpacing
        pushStackView.spacing = 20
        pushStackView.axis = .horizontal
        pushStackView.alignment = .center
        pushStackView.translatesAutoresizingMaskIntoConstraints = false
        pushStackView.frame.origin =  CGPoint(x: 20, y: 0)
        return pushStackView
    }()
    
    let tagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3.0
        button.setTitle("Tags", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor().colorFromHex(hexColor: "#8a8a92")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    let subscribeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3.0
        button.setTitle("Subscribe", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor().colorFromHex(hexColor: "#8a8a92")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    let unSubscribeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3.0
        button.setTitle("UnSubscribe", for: .normal)
        button.isEnabled = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor().colorFromHex(hexColor: "#8a8a92")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let getSubscriptionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3.0
        button.setTitle("getSubscription", for: .normal)
        button.titleLabel?.numberOfLines = 3
        button.titleLabel?.textAlignment = .center
        button.isEnabled = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor().colorFromHex(hexColor: "#8a8a92")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 5
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonStackView
    }()
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(callViewModifier(notfication:)), name: .postRegisterCallback, object: nil)
        setUpView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .postRegisterCallback, object: nil)
    }
    
    @objc func callViewModifier(notfication: NSNotification) {
        
        if notfication.userInfo!["enable"] != nil, let value = notfication.userInfo!["enable"] as? Bool {
            enableButtons(enableButton: value)
        }else {
            enableButtons(enableButton: false)
        }
        
    }
    
    
    private func setUpView() {
        self.title = "Hello Push"
        self.view.backgroundColor = UIColor.white
        
        
        pushStackView.addArrangedSubview(pushLabel)
        pushStackView.addArrangedSubview(pushSwitch)
        pushSwitch.addTarget(self, action:#selector(PushViewController.enablePush), for: .valueChanged)
        
        
        tagButton.addTarget(self, action: #selector(PushViewController.getTags), for: .touchUpInside)
        getSubscriptionButton.addTarget(self, action: #selector(PushViewController.getSubscription), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(PushViewController.subscribeTag), for: .touchUpInside)
        unSubscribeButton.addTarget(self, action: #selector(PushViewController.unSubscribeTag), for: .touchUpInside)

        buttonStackView.addArrangedSubview(tagButton)
        buttonStackView.addArrangedSubview(subscribeButton)
        buttonStackView.addArrangedSubview(unSubscribeButton)
        buttonStackView.addArrangedSubview(getSubscriptionButton)
       // buttonStackView.frame = CGRect(x: 20, y: 140, width: 80, height: 80)
        self.view.addSubview(responseLabel)
        self.view.addSubview(pushStackView)
        self.view.addSubview(buttonStackView)
        
        responseLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":responseLabel]))
        pushStackView.topAnchor.constraint(equalTo: responseLabel.bottomAnchor, constant: 30).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":pushStackView]))
        
        buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-30).isActive = true
        
        buttonStackView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        //buttonStackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonStackView]))
        
    }
    
    @objc private func enablePush() {
        if pushSwitch.isOn {
            initializePush()
        } else{
            unRegisterPush()
        }
    }
    
}


extension UIColor {
    func colorFromHex(hexColor: String) -> UIColor {
        var hexString = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb: UInt32 = 0
        
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat((rgb & 0x0000FF)) / 255.0 ,
                            alpha: 1.0)
    }
}

extension Notification.Name {
    static let postRegisterCallback = Notification.Name("postRegisterCallback")
}

