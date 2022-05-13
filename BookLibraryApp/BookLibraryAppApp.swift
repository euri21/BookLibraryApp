//
//  BookLibraryAppApp.swift
//  BookLibraryApp
//
//  Created by Solution888 on 5/12/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct BookLibraryAppApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView(
                store: Store(
                    initialState: .init(),
                    reducer: mainTabReducer,
                    environment: .init()
                )
            )
        }
    }
    
    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().tintColor = UIColor(Color.gray)
            UITabBar.appearance().barTintColor = UIColor(Color.gray)
            
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
            
            return true
        }
    }
}
