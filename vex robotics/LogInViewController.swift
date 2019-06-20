//
//  LogInViewController.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 12/1/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import UIKit


var signUpActive = true

class LogInViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    @IBAction func pickImage(sender: AnyObject)
    {
        var image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        pickedImage.image = image
    }
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    @IBAction func pause(sender: AnyObject)
    {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    @IBAction func restore(sender: AnyObject)
    {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func createAlert(sender: AnyObject)
    {
        var alert = UIAlertController(title: "Hey There!", message: "Are you sure", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func displayAlert(title:String, error:String)
    {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpToggleButton: UIButton!
    @IBOutlet var alreadyRegistered: UILabel!
    
    
    
    @IBAction func toggleSignUp(sender: AnyObject)
    {
        if signUpActive == true
        {
            signUpActive = false
            signUpLabel.text = "Use the form below to log in"
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not registered?"
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        }
            
        else
        {
            signUpActive = true
            signUpLabel.text = "Use the form below to sign up"
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already registered?"
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
            
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject)
    {
        var error = ""
        
        if username.text == "" || password.text == ""
        {
            error = "Please enter a username and password"
        }
        
        if error != ""
        {
            displayAlert("Error in Form", error: error)
        }
            
        else
        {
            self.pause(error)
            
            
                if signUpActive == true
                {
                    var user = PFUser()
                    user.username = username.text
                    user.password = password.text
                    user.email = username.text
                    
                    user.signUpInBackgroundWithBlock {
                        (succeeded: Bool!, signUpError: NSError!) -> Void in
                        
                        self.restore(error)
                        if signUpError == nil {
                            // Hooray! Let them use the app now.
                            
                            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                            println("Signed up")
                        } else {
                            if let errorString = signUpError.userInfo?["error"] as? NSString
                            {
                                error = errorString
                                
                            }
                                
                            else
                            {
                                error = "Please try again later."
                            }
                            // Show the errorString somewhere and let the user try again.
                            
                            self.displayAlert("Could Not Sign Up", error: error)
                        }
                    }
                } // if signUpActive true
                
            else
            {
                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                    (user: PFUser!, signUpError: NSError!) -> Void in
                    
                    self.restore(error)
                    if signUpError == nil {
                        // Do stuff after successful login.
                        
                        self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                        println("signed in")
                    } else
                    {
                        // The login failed. Check error to see why.
                        if let errorString = signUpError.userInfo?["error"] as? NSString
                        {
                            error = errorString
                            
                        }
                            
                        else
                        {
                            error = "Please try again later."
                        }
                        // Show the errorString somewhere and let the user try again.
                        
                        self.displayAlert("Could Not Sign Up", error: error)
                    }
                }
            } // if signUpActive false
        } // end if error is not blank
        
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // class functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        toggleSignUp(self)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil
        {
            self.performSegueWithIdentifier("jumpToUserTable", sender: 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.signUp(true)
        return true;
    }

}

