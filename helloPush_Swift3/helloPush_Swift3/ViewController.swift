/*
 *     Copyright 2016 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMessage), name: NSNotification.Name(rawValue: "action"), object: nil)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}

