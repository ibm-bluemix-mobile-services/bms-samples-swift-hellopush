//
//  ViewController.swift
//  hellopush
//
//  Created by Anantha Krishnan K G on 11/12/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import UserNotifications
import BMSCore
import BMSPush

public var responseText: String?
public var isSuccess: Bool?

class ViewController: UIViewController {

    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var outputLabel: UILabel!
    @IBOutlet var registerButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMessage), name: NSNotification.Name(rawValue: "action"), object: nil)
    
    }
    @IBAction func registerForPush(_ sender: UIButton) {
        let alert = UIAlertController(title: "Let Us Send You Push Notifications?", message: "We'll only notify you of content that's interesting and relevant to YOU.",preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Yes, Please", style: .default, handler: { (action) -> Void in
            self.appDelegate.registerForPush()
        })
        let cancel = UIAlertAction(title: "No, Thanks", style: .destructive, handler: { (action) -> Void in
            self.outputLabel.text = "User denied permission"
            self.topLabel.text = "Bummer"
            self.bottomLabel.text = "Something Went Wrong"
        })
        alert.addAction(cancel)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateMessage () {
        
        DispatchQueue.main.async(execute: {
            self.outputLabel.text = responseText
            self.topLabel.text = isSuccess! ?  "Yay!" : "Bummer";
            self.bottomLabel.text = isSuccess! ? "You Are Connected" : "Something Went Wrong";
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

