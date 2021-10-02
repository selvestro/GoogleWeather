//
//  AppDelegate.swift
//  GoogleWeather
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import UIKit
import GoogleMaps

let GoogleAPI_KEY = "AIzaSyBlobGsd_klnHXhrHEbQ6gL-w6I8qjvjIY"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(GoogleAPI_KEY)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
