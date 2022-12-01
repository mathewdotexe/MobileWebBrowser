//
//  Final335App.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI
import Firebase
import GoogleSignInSwift
import GoogleSignIn

@main
struct Final335App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene
    {
        
        WindowGroup
        {
            
            TabView
            {
                
                BrowserView()
                    .tabItem {
                        
                        Label("Browser", systemImage: "globe")
                        
                    }

                HistoryView()
                    .tabItem {
                        
                        Label("History", systemImage: "clock")
                            
                        
                    }
                
                BookmarksView()
                    .tabItem {
                        
                        Label("Bookmarks", systemImage: "book")
                            
                        
                    }
                   
                
            }
            .onAppear()
            {
                
                UITabBar.appearance().backgroundColor = UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1)
                   
            }
            .accentColor(Color.yellow)
        }
    }
}

class AppDelegate:  NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

}
