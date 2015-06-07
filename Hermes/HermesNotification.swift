import UIKit

public class HermesNotification: NSObject {
  
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
  
  weak private var _target: AnyObject?
  public var target: AnyObject? {
    get {
      return _target
    }
  }
  
  private var _selector: Selector?
  public var selector: Selector? {
    get {
      return _selector
    }
  }
  
  // This allows you to customize what happens when you touch a notification
  public func setTarget(target: AnyObject?, selector: Selector?) {
    _target = target
    _selector = selector
  }
}