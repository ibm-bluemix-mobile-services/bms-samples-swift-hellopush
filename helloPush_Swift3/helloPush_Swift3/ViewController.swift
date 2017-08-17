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

class ViewController: UIViewController {

    @IBOutlet var textViewResult: UITextView!
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
    
    
    @IBAction func pushAction(_ sender: UISwitch) {
        
        if sender.isOn{
            
            let alert = UIAlertController(title: "Let Us Send You Push Notifications?", message: "We'll only notify you of content that's interesting and relevant to YOU.",preferredStyle: .alert)

            let submitAction = UIAlertAction(title: "Yes, Please", style: .default, handler: { (action) -> Void in
                self.textViewResult.text = "started Registration \n"
                
                self.appDelegate.registerForPush()
                
                //self.registerButton.isUserInteractionEnabled = true
                //self.registerButton.backgroundColor = UIColor(red: 62/255, green: 192/255, blue: 239/255, alpha: 1.0)
            })
            let cancel = UIAlertAction(title: "No, Thanks", style: .destructive, handler: { (action) -> Void in
                self.textViewResult.text = "User denied permission \n"
                sender.setOn(false, animated: true)
            })
            alert.addAction(cancel)
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
        else{
            textViewResult.text = "";
            textViewResult.text = "Unregister Push"
            appDelegate.unRegisterPush()
        }

    }
    func updateMessage () {
        
        var responseLabelText = self.textViewResult.text
        responseLabelText = "\(responseLabelText) \n Response Text: \(responseText) \n\n"
        DispatchQueue.main.async(execute: {
            self.textViewResult.text = responseLabelText
        })
    }

}

