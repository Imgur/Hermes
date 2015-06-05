import UIKit
import Hermes

class ViewController: UIViewController, HermesDelegate {
  let hermes = Hermes.sharedInstance

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .whiteColor()
    hermes.delegate = self
    
    var notification1 = HermesNotification()
    notification1.text = NSAttributedString(string: "Testing 123!!!")
    notification1.image = UIImage(named: "notification_icon")
    notification1.highlightColor = .greenColor()
    notification1.setTarget(self, selector:"foo:")
    
    var notification2 = HermesNotification()
    notification2.text = NSAttributedString(string: "Someone just gave you a gift!")
    notification2.image = UIImage(named: "notification_icon")
    notification2.highlightColor = .redColor()
    
    var notification3 = HermesNotification()
    notification3.text = NSAttributedString(string: "ZOMG ROFLCOPTERS!!! This is reallllly long omg hahaha askljd alksjd asd")
    notification3.image = UIImage(named: "notification_icon")
    notification3.highlightColor = .yellowColor()

    hermes.postNotifications([notification1, notification2, notification3, notification1, notification2, notification3])
    
    var imageView = UIImageView(image: UIImage(named: "background")!)
    view.addSubview(imageView)
    imageView.frame = view.bounds
    imageView.contentMode = .ScaleAspectFit
    imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
  }
  
  // MARK: - HermesDelegate
//  func hermesNotificationViewForNotification(#hermes: Hermes, notification: HermesNotification) -> HermesNotificationView? {
//    return HermesNotificationView()
//  }
  
  func foo(obj: AnyObject) {
    println("foo")
  }
}

