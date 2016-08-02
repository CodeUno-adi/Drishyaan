//
//  CircleTransitionAnimator.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit
var toggleController: Bool = true


class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning{
  
  weak var transitionContext: UIViewControllerContextTransitioning?
  
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.5;
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    
    let containerView = transitionContext.containerView()
    
    if toggleController
    {
      print("1")
      _ = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! CarTableViewController
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! AddRowViewController
      let button = toViewController.transitionButton
      
      containerView!.addSubview(toViewController.view)

      
      let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
      let extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
      let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
      let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
      
      let maskLayer = CAShapeLayer()
      maskLayer.path = circleMaskPathFinal.CGPath
      toViewController.view.layer.mask = maskLayer
    
      let maskLayerAnimation = CABasicAnimation(keyPath: "path")
      maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
      maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
      maskLayerAnimation.duration = self.transitionDuration(transitionContext)
      maskLayerAnimation.delegate = self
      maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
      
      toggleController = false
    }
    else
    {
      print("2")
      let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! AddRowViewController
      let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! CarTableViewController
      let button = fromViewController.transitionButton
      
      containerView!.addSubview(toViewController.view)
      
      
      let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
      let extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
      let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
      let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
      
      let maskLayer = CAShapeLayer()
      maskLayer.path = circleMaskPathFinal.CGPath
      toViewController.view.layer.mask = maskLayer
      
      let maskLayerAnimation = CABasicAnimation(keyPath: "path")
      maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
      maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
      maskLayerAnimation.duration = self.transitionDuration(transitionContext)
      maskLayerAnimation.delegate = self
      maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
      
      toggleController = true
      
    }
  }
  
  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
    self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
  }
  
}
