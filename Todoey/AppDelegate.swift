//
//  AppDelegate.swift
//  Todoey
//
//  Created by Baran Atmanoglu on 1/22/18.
//  Copyright © 2018 Baran Atmanoglu. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
      
        
        do{
            _ = try Realm()
            
        }
        catch{
            print("Error initialising new Realm \(error)")
        }
        
        
        
        return true
    }

    


}

