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
    notification1.image = UIImage(named: "logo")
    notification1.highlightColor = .greenColor()
    notification1.setTarget(self, selector:"foo:")
    notification1.soundPath = NSBundle.mainBundle().pathForResource("notify", ofType: "wav")
    
    var notification2 = HermesNotification()
    notification2.text = NSAttributedString(string: "Someone just gave you a gift!")
    notification2.image = UIImage(named: "logo")
    notification2.highlightColor = .redColor()
    
    var notification3 = HermesNotification()
    notification3.text = NSAttributedString(string: "ZOMG ROFLCOPTERS!!! This is reallllly long omg hahaha askljd alksjd asd")
    notification3.image = UIImage(named: "logo")
    notification3.highlightColor = .yellowColor()

    hermes.postNotifications([notification1, notification2, notification3, notification1, notification2, notification3])
  }
  
  // MARK: - HermesDelegate
//  func hermesNotificationViewForNotification(#hermes: Hermes, notification: HermesNotification) -> HermesNotificationView? {
//    return HermesNotificationView()
//  }
  
  func foo(obj: AnyObject) {
    println("foo")
  }
}

