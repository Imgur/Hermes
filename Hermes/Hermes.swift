import UIKit

@objc public protocol HermesDelegate {
  /**
  :param: hermes the Hermes instance
  :param: notification the notification being made
  :returns: the notification view, or nil to use HermesDefaultNotificationView
  */
  optional func hermesNotificationViewForNotification(#hermes: Hermes, notification: HermesNotification) -> HermesNotificationView?
}

/**
Hermes is an in-app notification system that has a simple interface and can work with just about any sort of notification you can think of.
Examples include, but are not limited to:

- Success alerts
- Failure alerts
- Push Notifications
- Social Notifications (someone just commented on your post!)

Notes:

- Currently, this library only works well when you keep your app in one orientation.  Switching between portrait and landscape causes some gnarly
bugs and still needs to be handled.
*/
public class Hermes: NSObject, HermesBulletinViewDelegate {
  // MARK: - Public variables
  // MARK: - Singleton
  /**
  You typically will never need to use more than one instance of Hermes
  */
  public static let sharedInstance = Hermes()

  // MARK: -
  weak public var delegate: HermesDelegate?

  // MARK: - private variables
  private var bulletinView: HermesBulletinView?
  private var notifications = [HermesNotification]() {
    didSet {
      showNotifications()
    }
  }

  /**
  When Hermes is waiting, he will collect all of your notifications. Use wait() and go() to tell Hermes when to collect and when to deliver notifications
  */
  private var waiting = false {
    didSet {
      if !waiting {
        showNotifications() 
      }
    }
  }
  
  // MARK: - Public methods
  
  /**
  Give Hermes one notification to post. If waiting == false, you'll see this notification right away
  
  :param: notification The notification you want Hermes to post
  */
  public func postNotification(notification: HermesNotification) {
    postNotifications([notification])
  }
  
  /**
  Give Hermes an array of notifications to post. If waiting == false, you'll see these notifications right away
  
  :param: notifications The notifications you want Hermes to post
  */
  public func postNotifications(notifications: [HermesNotification]) {
    self.notifications += notifications
  }
  
  /**
  Tell Hermes to wait and you can queue up multiple notifications
  */
  public func wait() {
    waiting = true
  }
  
  /**
  Done queuing up those notifications? Tell Hermes to go!
  */
  public func go() {
    waiting = false
    showNotifications()
  }
  
  public func close() {
    bulletinView?.close()
  }
  
  // MARK: - private methods
  
  /**
  This method will attempt to show all currently queued up notifications.  If Hermes has waiting set to true, 
  or if there are not notifications, this method will do nothing
  */
  private func showNotifications() {
    if waiting || notifications.count == 0 || bulletinView != nil {
      return
    }
    
    bulletinView = HermesBulletinView()
    bulletinView!.delegate = self
    bulletinView!.notifications = notifications
    
    bulletinView!.show()
  }
  
  // MARK - HermesBulletinViewDelegate
  
  func bulletinViewDidClose(bulletinView: HermesBulletinView) {
    notifications.removeAll(keepCapacity: true)
    self.bulletinView = nil
    showNotifications()
  }
  
  func bulletinViewNotificationViewForNotification(notification: HermesNotification) -> HermesNotificationView? {
    return delegate?.hermesNotificationViewForNotification?(hermes: self, notification: notification)
  }
}
