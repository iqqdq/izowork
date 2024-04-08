import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB8-NiW7qtyEXNy_n0AfyFYeTxto8lVfGc")
    GeneratedPluginRegistrant.register(with: self)
    
    // Initialize FirebaseApp
    FirebaseApp.configure()

    // Initialize Firebase push-notification plugin
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
