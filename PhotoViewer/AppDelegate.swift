//
//  AppDelegate.swift
//  PhotoViewer
//
//  Created by Admin on 11/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Onboard

let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

let kUserHasOnboardedKey = "user_has_onboarded";

//    PhotoViewer
//Key:
//d40160a09e753f27b90ffa63aeed67d5

//Secret:
//7d4150c53affd256

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         window?.tintColor = themeColor
        
        // determine if the user has onboarded yet or not
       let userHasOnboarded = UserDefaults.standard.bool(forKey: kUserHasOnboardedKey)
        //[[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
        
        // if the user has already onboarded, just set up the normal root view controller
        // for the application
        if (userHasOnboarded) {
            setupNormalRootViewController();
        }else {
            window?.rootViewController = generateStandardOnboardingVC();
        }
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupNormalRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as! UINavigationController
        window?.rootViewController = secondViewController
    }
    
    func generateStandardOnboardingVC() -> OnboardingViewController{
        
        let firstPage = OnboardingContentViewController(title: "Photo Viewer", body: "You can View your Photos with this awesome tool.", image: UIImage(named: "instaNew"), buttonText: "") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let secondPage = OnboardingContentViewController(title: "Import", body: "You can import your photos from Instagram, Flicker, Pintrest etc.", image: UIImage(named: "flicker"), buttonText: "") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }
        
        let thirdPage = OnboardingContentViewController(title: "Zoom", body: "You can pinch in your photos to zoom them..", image: UIImage(named: "pintrest"), buttonText: "Next") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            self.skip()
        }
        
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "pic1"), contents: [firstPage, secondPage, thirdPage])
        
        onboardingVC?.shouldFadeTransitions = true;
        onboardingVC?.fadePageControlOnLastPage = true;
        onboardingVC?.fadeSkipButtonOnLastPage = true;
        onboardingVC?.allowSkipping = true;
        onboardingVC?.skipHandler = {
            self.skip()
        }
       
       
        return onboardingVC!
       

    }
    
    func skip() {
        self.setupNormalRootViewController()
    }


}

