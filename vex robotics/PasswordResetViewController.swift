//
//  PasswordResetViewController.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 12/22/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBAction func passwordReset(sender: AnyObject)
    {
        
        if emailAddress.text.isEmail()
        {
            println("isvalid")
            PFUser.requestPasswordResetForEmail(emailAddress.text)
            
            // inform user
            var alert = UIAlertController(title: "Password Reset", message: "Please check your e-mail for a link to reset your password.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
                signUpActive = false
                self.performSegueWithIdentifier("backToSignUp", sender: self)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        else // if emailAddress is invalid
        {
            var alert = UIAlertController(title: "Invalid e-mail address", message: "Please enter a valid e-mail address.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.passwordReset(emailAddress.text)
        return true;
    }

}
