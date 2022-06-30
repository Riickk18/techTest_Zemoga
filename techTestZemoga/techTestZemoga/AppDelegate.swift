//
//  AppDelegate.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        doRealmMigrations()
        setUpNavigationBar()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func doRealmMigrations(){
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in

        })
        
        let configCheck = Realm.Configuration();
        do {
            let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            print("schema version \(fileUrlIs)")
        } catch  {
            print(error)
        }
        print("Dirección de la Base de Datos")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func setUpNavigationBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        let img = UIImage(named: "navBar_background")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        navigationBarAppearance.setBackgroundImage(img, for: .default)
        
        let newNavBarAppaearance = UINavigationBarAppearance()
        newNavBarAppaearance.backgroundImage = img
        navigationBarAppearance.standardAppearance = newNavBarAppaearance
        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearance.standardAppearance
    }


}

