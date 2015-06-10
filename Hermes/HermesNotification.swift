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
  public var action: Optional<(HermesNotification) -> ()> = nil
  
  public func invokeAction() {
    if action != nil {
      action!(self)
    }
  }
}
