import UIKit

class HermesDefaultNotificationView: HermesNotificationView {
  override var notification: HermesNotification? {
    didSet {
      textLabel.attributedText = notification?.attributedText
      colorView.backgroundColor = notification?.color
      imageView.image = notification?.image
      layoutSubviews()
    }
  }
  
  private var imageView = UIImageView()
  private var textLabel = UILabel()
  private var colorView = UIView()
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.contentMode = .ScaleAspectFit
    textLabel.textColor = .whiteColor()
    textLabel.font = UIFont(name: "HelveticaNeue", size: 14)
    textLabel.numberOfLines = 3
    addSubview(imageView)
    addSubview(textLabel)
    addSubview(colorView)
  }
  
  convenience init(notification: HermesNotification) {
    self.init(frame: CGRectZero)
    self.notification = notification
  }
  
  override func layoutSubviews() {
    let margin = CGFloat(4)
    let colorHeight = CGFloat(2)
    
    imageView.frame = CGRectMake(margin * 2, 0, 30, 30)
    imageView.center.y = CGRectGetMidY(bounds) - colorHeight
    
    var leftRect = CGRect()
    var rightRect = CGRect()
    CGRectDivide(bounds, &leftRect, &rightRect, CGRectGetMaxX(imageView.frame), .MinXEdge)
  
    var space: CGFloat = 20
    var constrainedSize = CGRectInset(rightRect, (space + margin) * 0.5, 0).size
    
    textLabel.frame.size = textLabel.sizeThatFits(constrainedSize)
    textLabel.frame.origin.x = CGRectGetMaxX(imageView.frame) + space
    textLabel.center.y = CGRectGetMidY(bounds) - colorHeight
    
    colorView.frame = CGRectMake(margin, bounds.size.height - colorHeight, bounds.size.width - 2 * margin, colorHeight)
    
    // This centers the text across the whole view, unless that would cause it to block the imageView
    textLabel.center.x = CGRectGetMidX(bounds)
    var leftBound = CGRectGetMaxX(imageView.frame) + space
    if textLabel.frame.origin.x < leftBound {
      textLabel.frame.origin.x = leftBound
    }
  }
}
