//
//  NavigationControllerDelegate.swift
//  Table
//
//  Created by Sadhana on 12/10/15.
//  Copyright © 2015 VinCorp. All rights reserved.
//

import UIKit
var originalChoice: Int = 3


class NavigationControllerDelegate: NSObject,UINavigationControllerDelegate
{
    var choice:Int = 0{didSet{assign()}}
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
    func assign()
    {
        originalChoice = choice
    }
    
    
        func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
        {
            print("or coohice is \(originalChoice)")
            if originalChoice >= 0 && originalChoice < 2
            {
                print("special case")
                if originalChoice == 1
                {
                    originalChoice = 3
                    return CircleTransitionAnimator()

                }
                else
                {
                    return CircleTransitionAnimator()
                }
            }
            else
            {
                return nil
            }
        }
    
}
