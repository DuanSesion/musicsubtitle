//
//  SceneDelegate.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        sceneEnter()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func sceneEnter() -> Void {
        WPKeyWindowDev = window
        FileManager.default.wp.createFileFolder()
        registerFont()
        registerAudioSession()
    }
    
    func registerFont() -> Void {
        if let url = Bundle.main.url(forResource: "Font.bundle/DIN-BoldAlternate", withExtension: "otf") {
            UIFont.wp.registerFont(fileURL: url)//DIN
        }
        
        if let url = Bundle.main.url(forResource: "Font.bundle/DINAlternate-bold", withExtension: "otf") {
            UIFont.wp.registerFont(fileURL: url)//DIN Alternate
        }
        
        //debugPrint(UIFont.familyNames)
    }
    
    func registerAudioSession() -> Void {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try session.overrideOutputAudioPort(.none)
            try session.setActive(true)
            
        } catch {
            print("Could not hide audio volume view: \(error)")
        }
    }

}
