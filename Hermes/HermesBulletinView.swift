import UIKit

protocol HermesBulletinViewDelegate: class {
  func bulletinViewDidClose(bulletinView: HermesBulletinView)
  func bulletinViewNotificationViewForNotification(notification: HermesNotification) -> HermesNotificationView?
}

let kMargin = 8 as CGFloat
let kNotificationHeight = 110 as CGFloat

class HermesBulletinView: UIView, UIScrollViewDelegate {
  weak var delegate: HermesBulletinViewDelegate?

  let scrollView = UIScrollView()
  var backgroundView: UIVisualEffectView?

  var currentPage: Int = 0
  var timer: NSTimer!
  
  var notifications = [HermesNotification]() {
    didSet {
      layoutNotifications()
    }
  }
  
  var tabView = UIView()
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
    addGestureRecognizer(panGestureRecognizer)
    
    let blurEffect = UIBlurEffect(style: .Dark)
    backgroundView = UIVisualEffectView(effect: blurEffect)
    backgroundView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
    
    scrollView.contentInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin)
    scrollView.delegate = self
    
    tabView.backgroundColor = UIColor(white: 1, alpha: 0.4)
    addSubview(backgroundView!)
    addSubview(scrollView)
    addSubview(tabView)
  }
  
  func pan(gesture: UIPanGestureRecognizer) {
    timer.invalidate()
    var pan = gesture.translationInView(gesture.view!.superview!)
    var startFrame = bulletinFrameInView(gesture.view!.superview!)
    var frame = startFrame
    
    var dy: CGFloat = 0
    var height = gesture.view?.superview!.bounds.size.height
    var k = height! * 0.2
    if pan.y < 0 {
      pan.y = pan.y / k
      dy = k * pan.y / (sqrt(pan.y * pan.y + 1))
    } else {
      dy = pan.y
    }
    
    frame.origin.y += dy
    self.frame = frame
    
    if gesture.state == .Ended {
      var layoutViewFrame = layoutViewFrameInView(gesture.view!.superview!)
      if dy > layoutViewFrame.size.height * 0.5 {
        close()
      } else {
        animateIn()
      }
    }
  }
  
  func animateIn() {
    var bulletinFrame = bulletinFrameInView(self.superview!)

    UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
      self.frame = bulletinFrame
      }, completion: { completed in
        self.scheduleCloseTimer(timeInterval: 3.0)
    })
    
  }
  
  func show(view: UIView = (UIApplication.sharedApplication().windows[0] as? UIView)!, animated: Bool = true) {
    // Add to main queue in case the view loaded but wasn't added to the window yet.  This seems to happen in my storyboard test app
    dispatch_async(dispatch_get_main_queue(),{
      view.addSubview(self)
      
      var bulletinFrame = self.bulletinFrameInView(self.superview!)
      var startFrame = bulletinFrame
      startFrame.origin.y += self.superview!.bounds.size.height
      
      self.frame = startFrame
      self.animateIn()
    })
  }
  
  func scheduleCloseTimer(#timeInterval: NSTimeInterval) {
    timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "nextPageOrClose", userInfo: nil, repeats: false)
  }
  
  func close() {
    var startFrame = bulletinFrameInView(superview!)
    var offScreenFrame = startFrame
    offScreenFrame.origin.y = superview!.bounds.size.height
    
    UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
      self.frame = offScreenFrame
      }, completion: { completed in
        self.removeFromSuperview()
        self.delegate?.bulletinViewDidClose(self)
    })
  }
  
  func contentOffsetForPage(page: Int) -> CGPoint {
    var boundsWidth = scrollView.bounds.size.width
    var pageWidth = boundsWidth - 2 * kMargin
    var contentOffset = CGPointMake(pageWidth * CGFloat(page) - scrollView.contentInset.left, scrollView.contentOffset.y)
    if contentOffset.x < -scrollView.contentInset.left {
      contentOffset.x = -scrollView.contentInset.left
    } else if contentOffset.x + scrollView.contentInset.right + scrollView.bounds.size.width > scrollView.contentSize.width {
      contentOffset.x = scrollView.contentSize.width - scrollView.bounds.size.width + scrollView.contentInset.right
    }
    return contentOffset
  }
  
  func nextPageOrClose() {
    currentPage = pageFromOffset(scrollView.contentOffset)
    var boundsWidth = scrollView.bounds.size.width
    var pageWidth = boundsWidth - 2 * kMargin
    var totalPages = Int(scrollView.contentSize.width / pageWidth)
    
    if currentPage + 1 >= totalPages {
      close()
    } else {
      var newPage = currentPage + 1
      CATransaction.begin()
      scrollView.setContentOffset(contentOffsetForPage(newPage), animated: true)
      CATransaction.setCompletionBlock({
        self.scheduleCloseTimer(timeInterval: 3.0)
      })
      CATransaction.commit()
    }
  }
  
  func bulletinFrameInView(view: UIView) -> CGRect {
    var bulletinFrame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height * 0.5)
    var notificationViewFrame = layoutViewFrameInView(view)
    
    bulletinFrame.origin = CGPointMake(0, view.bounds.size.height - notificationViewFrame.size.height)
    return bulletinFrame
  }
  
  func layoutViewFrameInView(view: UIView) -> CGRect {
    return CGRectMake(0, 0, view.bounds.size.width, kNotificationHeight)
  }
  
  func notificationViewFrameInView(view: UIView) -> CGRect {
    var frame = layoutViewFrameInView(view)
    frame.origin.x += kMargin
    frame.size.width -= kMargin * 2
    frame.origin.y += 10 // TODO: configurable
    frame.size.height -= 10  // TODO: configurable
    return frame
  }
  
  func layoutNotifications() {
    // TODO: handle a relayout -- relaying out this view right now adds duplicate noitficationViews
    if superview == nil {
      return
    }
    
    var i = 0
    var notificationViewFrame = notificationViewFrameInView(superview!)

    for notification in notifications {
      notificationViewFrame.origin.x = CGFloat(i) * notificationViewFrame.size.width
      i++

      var notificationView = delegate?.bulletinViewNotificationViewForNotification(notification)
      if notificationView == nil {
        notificationView = HermesDefaultNotificationView()
      }
      notificationView!.frame = notificationViewFrame
      notificationView!.notification = notification
      
      if notification.target != nil && notification.selector != nil {
        var tapGesture = UITapGestureRecognizer(target: notification.target!, action: notification.selector!)
        notificationView?.addGestureRecognizer(tapGesture)
      }
      
      scrollView.addSubview(notificationView!)
    }
    
    scrollView.contentSize = CGSizeMake(CGRectGetMaxX(notificationViewFrame), scrollView.bounds.size.height)
  }
  
  override func layoutSubviews() {
    backgroundView?.frame = CGRectMake(0, 0, bounds.size.width, superview!.bounds.size.height)

    scrollView.frame = bounds
    
    var tabViewFrame = CGRectMake(0, 4, 40, 2)
    tabView.frame = tabViewFrame
    tabView.center = CGPointMake(bounds.size.width / 2, tabView.center.y)
    
    layoutNotifications()
  }
  
  func pageFromOffset(offset: CGPoint) -> Int {
      var boundsWidth = scrollView.bounds.size.width
      var pageWidth = boundsWidth
      return Int((offset.x + pageWidth * 0.5) / pageWidth)
  }
  
  // MARK: - UIScrollViewDelegate
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    timer.invalidate()
    currentPage = pageFromOffset(scrollView.contentOffset)
  }
  
  func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    var currentPage = self.currentPage
    var targetOffset = targetContentOffset.memory
    var targetPage = pageFromOffset(targetOffset)
    
    var newPage = currentPage
    if targetPage > currentPage {
      newPage++
    } else if targetPage < currentPage {
      newPage--
    }
    
    targetContentOffset.initialize(self.contentOffsetForPage(newPage))
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    scheduleCloseTimer(timeInterval: 3.0)
  }
}
