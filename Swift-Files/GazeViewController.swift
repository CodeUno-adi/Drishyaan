//
//  GazeViewController.swift
//  Table
//
//  Created by Aditya on 12/13/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import UIKit
import AVFoundation
import Parse


class GazeViewController: UIViewController
{
    private var visage : Visage?
    private let notificationCenter : NSNotificationCenter = NSNotificationCenter.defaultCenter()

    @IBOutlet weak var cameraView: UIView!
    
    var controlObject: PFObject? = nil
    
    var carStarted:Bool = false
    
    var vehicleId: String = String()
        {didSet{assign()}}
    var trueVehicleId: String = String()
    
    let emojiLabel : UILabel = UILabel(frame: UIScreen.mainScreen().bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup "Visage" with a camera-position (iSight-Camera (Back), FaceTime-Camera (Front)) and an optimization mode for either better feature-recognition performance (HighPerformance) or better battery-life (BatteryLife)
        visage = Visage(cameraPosition: Visage.CameraDevice.FaceTimeCamera, optimizeFor: Visage.DetectorAccuracy.HigherPerformance)
        
        //If you enable "onlyFireNotificationOnStatusChange" you won't get a continuous "stream" of notifications, but only one notification once the status changes.
        visage!.onlyFireNotificatonOnStatusChange = false
        
        
        //You need to call "beginFaceDetection" to start the detection, but also if you want to use the cameraView.
        visage!.beginFaceDetection()
        
        //This is a very simple cameraView you can use to preview the image that is seen by the camera.
        
        //        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        //        visualEffectView.frame = self.view.bounds
        //        self.view.addSubview(visualEffectView)
        
        
        //Subscribing to the "visageFaceDetectedNotification" (for a list of all available notifications check out the "ReadMe" or switch to "Visage.swift") and reacting to it with a completionHandler. You can also use the other .addObserver-Methods to react to notifications.
        NSNotificationCenter.defaultCenter().addObserverForName("visageFaceDetectedNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.25, animations: {
                self.emojiLabel.alpha = 1
            })
            
            
            
            
//            if ((self.visage!.hasSmile == true && self.visage!.isWinking == true)) {
//                self.emojiLabel.text = "😜"
//            }
            if ((self.visage!.hasSmile == true && self.visage!.isWinking == false)) {
                self.emojiLabel.text = "😃"
                self.controlObject?["control_field"] = "START"
                self.controlObject?.saveInBackground()
                self.carStarted = true
                
            }
            
            else if ((self.visage!.rightEyeClosed == true && self.visage!.leftEyeClosed == false)) {
                self.emojiLabel.text = "😉"
                self.controlObject?["control_field"] = "LEFT"
                self.controlObject?.saveInBackground()

            }
            
            else if ((self.visage!.rightEyeClosed == false && self.visage!.leftEyeClosed == true)) {
                self.emojiLabel.text = "😉"
                self.controlObject?["control_field"] = "RIGHT"
                self.controlObject?.saveInBackground()
                
            }
            else if((self.visage!.leftEyeClosed == true && self.visage!.rightEyeClosed == true))
            {
                self.controlObject?["control_field"] = "STOP"
                self.controlObject?.saveInBackground()
                self.carStarted = false
            }
            
            else {
                self.emojiLabel.text = "😐"
                if (self.carStarted)
                {
                    self.controlObject?["control_field"] = "STRAIGHT"
                    self.controlObject?.saveInBackground()
 
                }
            }
        })
        
        //The same thing for the opposite, when no face is detected things are reset.
        NSNotificationCenter.defaultCenter().addObserverForName("visageNoFaceDetectedNotification", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.5, animations: {
                self.emojiLabel.alpha = 0.25
            })
        })
        retrieveRecord()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        print("height is \(cameraView.bounds.height) and width is \(cameraView.bounds.width)")
        self.visage!.visageCameraView.frame = cameraView.bounds
        self.visage!.previewLayer.frame = cameraView.bounds
        
        
        self.visage!.visageCameraView.layer.addSublayer(visage!.previewLayer)
        self.cameraView.addSubview(visage!.visageCameraView)
        
        emojiLabel.text = "😐"
        emojiLabel.font = UIFont.systemFontOfSize(50)
        emojiLabel.textAlignment = .Center
        self.view.addSubview(emojiLabel)
        
    }
    
    func assign()
    {
        self.trueVehicleId = vehicleId
    }
    
    func retrieveRecord()
    {
        let query = PFQuery(className: "UserTable")
        
        let u_id = PFUser.currentUser()!["user_id"] as! String
        query.whereKey("user_id", equalTo: u_id)
        query.whereKey("vehicle_id", equalTo: self.trueVehicleId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) from usertable.")
                // Do something with the found objects
                if let retrievedList = objects as [PFObject]! {
                    for object in retrievedList {
                        self.controlObject = object
                        
                        
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }


    }
}
