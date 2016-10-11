//
//  AddRowViewController.swift
//  Table
//
//  Created by Aditya on 12/10/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import UIKit
import Parse

struct MoveKeyboard {
    static let KEYBOARD_ANIMATION_DURATION : CGFloat = 0.3
    static let MINIMUM_SCROLL_FRACTION : CGFloat = 0.2;
    static let MAXIMUM_SCROLL_FRACTION : CGFloat = 0.8;
    static let PORTRAIT_KEYBOARD_HEIGHT : CGFloat = 216;
    static let LANDSCAPE_KEYBOARD_HEIGHT : CGFloat = 162;
}

class AddRowViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

   
    @IBOutlet weak var transitionButton: UIButton!
    var segueChoice:NavigationControllerDelegate!

    @IBOutlet weak var vehicleName: UITextField!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var vehicleType: UIPickerView!
    
    @IBOutlet weak var subFieldLabel: UILabel!
    
    @IBOutlet weak var subFieldText: UITextField!
    
    let dataSource = ["None","Car","Wheelchair"]
    
    var tableViewControl: CarTableViewController!
    var toSendObj: Vehicle!
    
    var animateDistance = CGFloat()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vehicleType.dataSource = self
        self.vehicleType.delegate = self
        
        self.vehicleName.delegate = self
        self.subFieldText.delegate = self
        
        
        segueChoice = NavigationControllerDelegate()
        
        toSendObj = Vehicle(name: "", type: "", controlField: "",subField: "")
        tableViewControl = CarTableViewController()
        
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Done(sender: UIBarButtonItem)
    
    {
        segueChoice.choice = 1
        toSendObj.name = vehicleName.text
        toSendObj.controlField = ""
        toSendObj.subField = subFieldText.text!
        if toSendObj.name == "" || toSendObj.type == "None" || toSendObj.subField == ""
        {
            callAlert()
        }
        else
        {
            print("name and type is \(toSendObj.name!) \(toSendObj.type!)")
            let currentUserId = PFUser.currentUser()!.objectForKey("user_id") as! String
            let tableViewObject = PFObject(className:"UserTable")
            tableViewObject["user_id"] = currentUserId
            tableViewObject["vehicle_name"] = toSendObj.name!
            tableViewObject["vehicle_type"] = toSendObj.type!
            tableViewObject["control_field"] = toSendObj.controlField
            tableViewObject["vehicle_id"] = toSendObj.subField
            tableViewObject.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    print("successfully added")
                } else {
                    // There was a problem, check error.description
                }
            }
            tableViewObject.pinInBackground()
            tableViewControl.recvObj = toSendObj
            print("all success")

            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    func callAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "please fill the mandatory fields", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func Cancel(sender: UIBarButtonItem)
    
    {
        segueChoice.choice = 1
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView == self.vehicleType
        {
            return 1
 
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.vehicleType
        {
            return dataSource.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch row
        {
            case 0:
                previewImage.image! = UIImage(named:"None")!

                print("the selected vehicle is \(dataSource[row])")
                    toSendObj.type = dataSource[row]
            
            case 1:
                previewImage.image! = UIImage(named:"car")!
                print("the selected vehicle is \(dataSource[row])")
                toSendObj.type = dataSource[row]
                subFieldLabel.text = "Car Reg.No"
                subFieldText.borderStyle = .RoundedRect
            case 2:
                previewImage.image! = UIImage(named: "wheelchair")!
                print("the selected vehicle is \(dataSource[row])")
                toSendObj.type = dataSource[row]
                subFieldLabel.text = "Vehicle Id"
                subFieldText.borderStyle = .RoundedRect

            default:
                print("invalid option")
            
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let textFieldRect : CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect : CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view)
        
        let midline : CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator : CGFloat = midline - viewRect.origin.y - MoveKeyboard.MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator : CGFloat = (MoveKeyboard.MAXIMUM_SCROLL_FRACTION - MoveKeyboard.MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction : CGFloat = numerator / denominator
        
        if heightFraction < 1.0 {
            heightFraction = 1.0
        }
        
        let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if (orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown) {
            animateDistance = floor(MoveKeyboard.PORTRAIT_KEYBOARD_HEIGHT * heightFraction)
        } else {
            animateDistance = floor(MoveKeyboard.LANDSCAPE_KEYBOARD_HEIGHT * heightFraction)
        }
        
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y -= animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var viewFrame : CGRect = self.view.frame
        viewFrame.origin.y += animateDistance
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(NSTimeInterval(MoveKeyboard.KEYBOARD_ANIMATION_DURATION))
        
        self.view.frame = viewFrame
        
        UIView.commitAnimations()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
