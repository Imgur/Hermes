import UIKit

protocol HermesNotificationDelegate: class {
    func notificationDidChangeAutoClose(notification: HermesNotification)
}

public class HermesNotification: NSObject {
  weak var delegate: HermesNotificationDelegate?
    
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
  public var attributedText: NSAttributedString?
  public var color: UIColor?
  public var image: UIImage?
  public var imageURL: NSURL?
  public var tag: String?
  public var soundPath: String?
  public var action: Optional<(HermesNotification) -> ()> = nil
  public var autoClose = true {
    didSet {
      if oldValue != autoClose {
        delegate?.notificationDidChangeAutoClose(self)
      }
    }
  }
  public func invokeAction() {
    if action != nil {
      action!(self)
    }
  }
}
