![hermes logo](http://i.imgur.com/1ZbEIuH.png)

![hermes text](http://i.imgur.com/vlg4X61.png)

Hermes is a simple and robust in-app notification system for iOS written in Swift.  It supports notifications with text/attributedText, an icon, a sound, and a color, and a target/selector pair--out of the box.  You can easily build your own notification template and add any number of attributes to a HermesNotification.

Hermes shows all queued up notifications at once, with an easy way to swipe through them (it will animate through them automatically if you don't touch any notifications for 3 seconds)

###Components
- **Hermes** (public)

  You will use Hermes.sharedInstance to post Notifications.  You can tell Hermes when to *wait()* and collect notifications and when to *go()* and post notifications as soon as Hermes has any.
  
- **Notification** (public, extendable)

  A Notification is a model that has attributes like text, image, sound, and color. You can extend or subclass Notifications and use them in custom NotificationViews
  
- **NotificationView** (public, extendable)

  A NotificationView is a UIView that displays Notifications.  Hermes lets you subclass and display your own NotificationViews that match your app's style.
  
- **BulletinView** (protected)

  The BulletinView is a UIView that shows 1 or many NotificationViews. Hermes does not let you subclass and use your own BulletinView.

###How to use
1. Make one or many Notifications
2. ```hermes.postNotifications([...])```

###Sample code

**Creating Notifications**
```swift
// uses Hermes singleton
let hermes = Hermes.sharedInstance

// 'Upload Complete!' success Notification
let successNotification = HermesNotification()
successNotification.text = "Upload complete!"
successNotification.image = UIImage(named: "success_icon")
successNotification.color = .greenColor()

// 'Upload failed :(' failure Notification
let failureNotification = HermesNotification()
failureNotification.text = "Upload failed :("
failureNotification.image = UIImage(named: "error_icon")
failureNotification.color = .redColor()
```

#### Posting Notifications

#####If you post Notifications while a Bulletin is already showing, it will show all of the new Notifications after the current Bulletin closes
```swift
hermes.postNotification(successNotification)
hermes.postNotification(failureNotification)
```

#####You can tell Hermes to wait and go, to collect a bunch of notifications before showing them 
```swift
// we could do use wait(), which tells Hermes to collect notifications without showing them yet
hermes.wait()

// post both the success and failure notification 
hermes.postNotification(successNotification)
hermes.postNotification(failureNotification)

// this tells Hermes to post all of the notifications in the queue
hermes.go()
```

#####Or, you can post an array of notifications that Hermes will show immediately
```swift
// we could have also done the above code by simply using postNotifications
hermes.postNotifications([successNotification, failureNotification])
```

It's that easy!

![hermes success notification](http://i.imgur.com/LnBCeAh.png)

