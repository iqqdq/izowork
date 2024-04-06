import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB8-NiW7qtyEXNy_n0AfyFYeTxto8lVfGc")
    GeneratedPluginRegistrant.register(with: self)
    
//    FirebaseApp.configure()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
