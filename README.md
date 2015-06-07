![hermes logo](http://i.imgur.com/1ZbEIuH.png)
![hermes](http://i.imgur.com/nahSRpD.png)

Hermes is a simple and robust in-app notification system for iOS written in Swift.  It supports notifications with text/attributedText, an icon, a sound, and a color, and a target/selector pair--out of the box.  You can easily build your own notification template and add any number of attributes to a HermesNotification.

Hermes shows all queued up notifications at once, with an easy way to swipe through them (it will animate through them automatically if you don't touch any notifications for 3 seconds)

###example
```swift
// uses Hermes singleton
let hermes = Hermes.sharedInstance

// a success notification template
let successNotification = HermesNotification()
successNotification.text = "Upload complete!"
successNotification.image = UIImage(named: "success_icon")
successNotification.color = .greenColor()

// a failure notification template
let failureNotification = HermesNotification()
failureNotification.text = "Upload failed :("
failureNotification.image = UIImage(named: "error_icon")
failureNotification.color = .redColor()

// if you post a notification while another notification stack is showing, it will show once the current stack is gone
hermes.postNotification(successNotification)
hermes.postNotification(failureNotification)

// we could do use wait(), which tells Hermes to collect notifications without showing them yet
hermes.wait()

// post both the success and failure notification 
hermes.postNotification(successNotification)
hermes.postNotification(failureNotification)

// this tells Hermes to post all of the notifications in the queue
hermes.go()

// we could have also done the above code by simply using postNotifications
hermes.postNotifications([successNotification, failureNotification])
```
