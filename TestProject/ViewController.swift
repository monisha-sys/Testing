//
//  ViewController.swift
//  TestProject
//
//  Created by Mounika Reddy on 16/03/21.
//

import UIKit


let ThrowingThreshold: CGFloat = 1000
let ThrowingVelocityPadding: CGFloat = 35

class ViewController: UIViewController {
    
  @IBOutlet weak var imageView: UIImageView!

    private var originalBounds = CGRect.zero
  private var originalCenter = CGPoint.zero

  private var animator: UIDynamicAnimator!
  private var attachmentBehavior: UIAttachmentBehavior!
  private var pushBehavior: UIPushBehavior!
  private var itemBehavior: UIDynamicItemBehavior!

  @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
    let location = sender.location(in: self.view)
    let boxLocation = sender.location(in: self.imageView)

    switch sender.state {
    case .began:
      print("Your touch start position is \(location)")
      print("Start location in image is \(boxLocation)")

      animator.removeAllBehaviors()

      let centerOffset = UIOffset(horizontal: boxLocation.x - imageView.bounds.midX, vertical: boxLocation.y - imageView.bounds.midY)
      attachmentBehavior = UIAttachmentBehavior(item: imageView, offsetFromCenter: centerOffset, attachedToAnchor: location)

      animator.addBehavior(attachmentBehavior)

    case .ended:
      print("Your touch end position is \(location)")
      print("End location in image is \(boxLocation)")

      animator.removeAllBehaviors()

      // 1
        let velocity = sender.velocity(in: view)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))

      if magnitude > ThrowingThreshold {
        // 2
        let pushBehavior = UIPushBehavior(items: [imageView], mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
        pushBehavior.magnitude = magnitude / ThrowingVelocityPadding

        self.pushBehavior = pushBehavior
        animator.addBehavior(pushBehavior)

        // 3
        let angle = Int(arc4random_uniform(20)) - 10

        itemBehavior = UIDynamicItemBehavior(items: [imageView])
        itemBehavior.friction = 0.2
        itemBehavior.allowsRotation = true
        itemBehavior.addAngularVelocity(CGFloat(angle), for: imageView)
        animator.addBehavior(itemBehavior)

        // 4
        let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
            self.resetImage()
      } else {
        resetImage()
      }

    default:
        attachmentBehavior.anchorPoint = sender.location(in: view)

      break
    }
  }

  func resetImage() {
    animator.removeAllBehaviors()

    UIView.animate(withDuration: 0.45) {
      self.imageView.bounds = self.originalBounds
      self.imageView.center = self.originalCenter
        self.imageView.transform = .identity
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    animator = UIDynamicAnimator(referenceView: view)
    originalBounds = imageView.bounds
    originalCenter = imageView.center
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

