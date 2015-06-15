import UIKit

public class HermesNotificationView: UIView {
  var notification: HermesNotification?
  let contentView = UIView()
    
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(contentView)
  }
  
  public override func layoutSubviews() {
    let margin = 8 as CGFloat
    contentView.frame = CGRectMake(margin, 0, bounds.size.width - 2 * margin, bounds.size.height - margin)
  }
}
