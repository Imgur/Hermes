import UIKit

public class HermesNotification: NSObject {
  public var text: NSAttributedString?
  public var highlightColor: UIColor?
  public var image: UIImage?
  public var imageURL: NSURL?
  public var tag: String?
  
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