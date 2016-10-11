//
//  LoginViewController.swift
//  Table
//
//  Created by Aditya on 12/11/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.delegate = self
        self.passWord.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if let destination = segue.destinationViewController as UIViewController!
            {
                if let dvc = destination as? CarTableViewController
                {
                    dvc.toggleIndicatorView = true
                }
            }
        
    }
    
    
    func performSegue()
    {
        performSegueWithIdentifier("showTableController", sender: self)

    }
    @IBAction func login(sender: UIButton)
    {
        PFUser.logInWithUsernameInBackground(userName.text!, password:passWord.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print("the user is \(user!.username)")
                self.performSegue()
                
            } else {
                print("login failed")
                print(error)
                // The login failed. Check error to see why.
            }
        }

    }
    
        
    

}
