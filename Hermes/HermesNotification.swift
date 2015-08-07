import UIKit

protocol HermesNotificationDelegate: class {
    func notificationDidChangeAutoClose(notification: HermesNotification)
}

public class HermesNotification: NSObject {
  weak var delegate: HermesNotificationDelegate?
  
  /// The text of the notification
  public var text: String? {
    set(text) {
      if (text != nil) {
        attributedText = NSAttributedString(string: text!)
      } else {
        attributedText = nil
      }
    }
    get {
      return attributedText?.string
    }
  }
  
  /// Text, but with fancy attributes instead of a regular `String`
  public var attributedText: NSAttributedString?
  
  /// The color of the bottom bar on the notification
  public var color: UIColor?
  
  /// The image to be displayed along with the notification
  public var image: UIImage?
  
  /// The URL to the image
  public var imageURL: NSURL?
  public var tag: String?
  
  /// The path to the sound to be played along with the notification
  public var soundPath: String?
  
  /// The code that should be executed when the notification is tapped on
  public var action: ((HermesNotification) -> Void)? = nil
  
  /// Should the notification close automatically?
  public var autoClose = true {
    didSet {
      if oldValue != autoClose {
        delegate?.notificationDidChangeAutoClose(self)
      }
    }
  }
  
  /// The time interval that the notification should stay on screen before self-dismissing
  public var autoCloseTimeInterval: NSTimeInterval = 3
  
  /// Force the notification to perform it's action
  public func invokeAction() {
    if action != nil {
      action!(self)
    }
  }
}
