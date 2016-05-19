import UIKit

extension UIImageView {
  func h_setImage(url url: NSURL) {
    // Using NSURLSession API to fetch image
    // TODO: maybe change NSURLConfiguration to add things like timeouts and cellular configuration
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: configuration)
    
    // NSURLRequest Object
    let request = NSURLRequest(URL: url)
    
    let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        // Set whatever image attribute to the returned data
        self.image = UIImage(data: data!)!
      } else {
        print(error)
      }
    })
    
    // Start the data task
    dataTask.resume()
  }
}

class HermesDefaultNotificationView: HermesNotificationView {
  override var notification: HermesNotification? {
    didSet {
      textLabel.attributedText = notification?.attributedText
      imageView.backgroundColor = notification?.color
      colorView.backgroundColor = notification?.color
      imageView.image = notification?.image
      if let imageURL  = notification?.imageURL {
        imageView.h_setImage(url: imageURL)
      }
      layoutSubviews()
    }
  }
  
  var style: HermesStyle = .Dark {
    didSet {
      textLabel.textColor = style == .Light ? .darkGrayColor() : .whiteColor()
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
    imageView.contentMode = .Center
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 5
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
    let margin: CGFloat = 4
    let colorHeight: CGFloat = 4
    
    imageView.hidden = notification?.image == nil && notification?.imageURL == nil
    imageView.frame = CGRectMake(margin * 2, 0, 34, 34)
    imageView.center.y = CGRectGetMidY(bounds) - colorHeight
    
    var leftRect = CGRect()
    var rightRect = CGRect()
    CGRectDivide(bounds, &leftRect, &rightRect, CGRectGetMaxX(imageView.frame), .MinXEdge)
  
    let space: CGFloat = 20
    let constrainedSize = CGRectInset(rightRect, (space + margin) * 0.5, 0).size
    
    textLabel.frame.size = textLabel.sizeThatFits(constrainedSize)
    textLabel.frame.origin.x = CGRectGetMaxX(imageView.frame) + space
    textLabel.center.y = CGRectGetMidY(bounds) - colorHeight
    
    colorView.frame = CGRectMake(margin, bounds.size.height - colorHeight, bounds.size.width - 2 * margin, colorHeight)
    
    // This centers the text across the whole view, unless that would cause it to block the imageView
    textLabel.center.x = CGRectGetMidX(bounds)
    let leftBound = CGRectGetMaxX(imageView.frame) + space
    if textLabel.frame.origin.x < leftBound {
      textLabel.frame.origin.x = leftBound
    }
  }
}
