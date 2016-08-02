//
//  ViewController.swift
//  Table
//
//  Created by Sadhana on 12/9/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import UIKit
import Parse

var dataSource: [Vehicle] = [Vehicle]()

class CarTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var segueChoice:NavigationControllerDelegate!
    
    @IBOutlet weak var ediBarButton: UIBarButtonItem!
   
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var toPassVehicleId: String = String()
    
//    var activityView:UIView = UIView()
//    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var recvArr: [Vehicle] = [Vehicle]()
    var toggleIndicatorView: Bool = false
        {didSet{assign1()}}
    var trueToggle: Bool = false
    
    var recvObj: Vehicle!{didSet{assign()}}
    
    var bottomBar: UIToolbar!
    var barItemArray:[UIBarButtonItem] = [UIBarButtonItem]()
    var logOutButton:UIBarButtonItem!
    var alignmentButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.alpha = 1
        
        segueChoice = NavigationControllerDelegate()
        tableView = UITableView()
        if let theTableView = tableView
        {
            theTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            theTableView.rowHeight = 65.0
            
            
        }
        ediBarButton.tag = 1
        self.bottomBar = UIToolbar()
        self.logOutButton = UIBarButtonItem(title: "LogOut", style: UIBarButtonItemStyle.Done, target: self, action: Selector("logOut"))
        
        //self.activityIndicator.hidesWhenStopped = true
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if let theTableView = tableView{
            
            
            theTableView.frame = CGRect(x: 0, y: 65, width: Double(self.view.bounds.size.width), height: Double(self.view.bounds.size.height))
            
            print("height is \(self.view.bounds.height)")
            
                //activityView.frame = self.view.bounds
//            activityIndicator.frame = self.view.bounds
            self.bottomBar.frame = CGRect(x: 0, y:Double(self.view.bounds.height - 50) , width: Double(self.view.bounds.size.width), height: 50)
            
            self.view.addSubview(theTableView)
            self.logOutButton.width = 50.0
            
            self.barItemArray.append(logOutButton)
            
            self.bottomBar.items = barItemArray
            self.view.addSubview(bottomBar)
//            self.activityView.addSubview(activityIndicator)
//            self.view.addSubview(activityView)
            print("length of dataSource is \(dataSource.count)")
            if trueToggle
            {
                print("true toggle is \(trueToggle)")
                trueToggle = false
                callRetrieveRecords()

            }
            else
            {
                self.tableView!.reloadData()
                
            }

        }
    
    }
    
    func logOut()
    {
        print("logout pressed")
        PFUser.logOut()
        print("successfully logged out")

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func assign()
    {
        print("received data is \(recvObj.name)")
        dataSource.append(recvObj)
    }
    
    func assign1()
    {
        self.trueToggle = toggleIndicatorView
    }
    
    func callRetrieveRecords()
    {
        //self.activityIndicator.startAnimating()
        retrieveRecords()
    }
    
    func retrieveRecords()
    {
        let query = PFQuery(className: "UserTable")
        
        let u_id = PFUser.currentUser()!["user_id"] as! String
        query.whereKey("user_id", equalTo: u_id)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) from usertable.")
                // Do something with the found objects
                if let retrievedList = objects as [PFObject]! {
                    for object in retrievedList {
                        let tempObj = Vehicle(name: object.objectForKey("vehicle_name") as! String!, type: object.objectForKey("vehicle_type") as! String!, controlField: object.objectForKey("control_field") as! String,subField: object.objectForKey("vehicle_id") as! String)
                        self.recvArr.append(tempObj)
                        
                        
                        
                    }
                    dataSource = self.recvArr
                    print("after retrieval datasource count is \(dataSource.count)")
                    self.tableView!.reloadData()
                    print("successfully called reload")
//                    self.activityIndicator.stopAnimating()
//                    self.activityView.hidden = true

                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return dataSource.count
        default:
            return 0
            
        }
    }
    
    
    @IBAction func editPressed(sender: UIBarButtonItem) 
    {
        if sender.tag == 1
        {
            self.tableView!.setEditing(true, animated: true)
            sender.title? = "Done"
            sender.tag = 0
        }
        else
        {
            self.tableView!.setEditing(false, animated: true)
            sender.title? = "Edit"
            sender.tag = 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
            let reuseIdentifier:String = "identifier"
            var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as UITableViewCell?
            if cell != nil{
                cell = UITableViewCell(style:UITableViewCellStyle.Subtitle,reuseIdentifier:reuseIdentifier)
            let obj = dataSource[indexPath.row]
            
            cell!.textLabel?.text = obj.name!
            cell!.detailTextLabel?.text = obj.subField
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if obj.type! == "Wheelchair"
            {
                cell!.imageView!.image = UIImage(named: "wheelchair")

            }
            else
            {
                cell!.imageView!.image = UIImage(named: "car")
            }
                
            
            return cell!
            }
            else
            {
                return cell!
            }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
                let u_id = PFUser.currentUser()!["user_id"] as! String

                let query = PFQuery(className:"UserTable")
                query.whereKey("user_id", equalTo:u_id)
                query.whereKey("vehicle_id", equalTo:dataSource[indexPath.row].subField)
            
                query.findObjectsInBackgroundWithBlock {
                    (results: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let retrievedList = results as [PFObject]! {
                            print("retrived list count to delete \(retrievedList.count)")
                            for object in retrievedList {
                                object.deleteInBackground()
                        // results contains players with lots of wins or only a few wins.
                        
                    }
                }
                
                }
        
            }
            dataSource.removeAtIndex(indexPath.row)
            self.tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return (UITableViewCellEditingStyle.Delete)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        toPassVehicleId = dataSource[indexPath.row].subField
        
        performSegueWithIdentifier("showGazeController", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "showAddController"
        {
            segueChoice.choice = 0
            print("set for + segue")

        }
        else if segue.identifier! == "showGazeController"
        {
            if let destination = segue.destinationViewController as UIViewController!
            {
                if let dvc = destination as? GazeViewController
                {
                    dvc.vehicleId = toPassVehicleId
                }
            }
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.barItemArray = [UIBarButtonItem]()
    }
    
    
}

