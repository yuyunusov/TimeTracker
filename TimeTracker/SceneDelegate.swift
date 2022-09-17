//
//  SceneDelegate.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 16.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let stopwatchTimer = StopwatchDisplayLinkTimer()
        let stopwatch = Stopwatch(stopwatchTimer: stopwatchTimer)

        let vc = MainVC(stopwatch: stopwatch)
        let nvc = UINavigationController(rootViewController: vc)

        window.rootViewController = nvc
        window.makeKeyAndVisible()

        stopwatchTimer.start()
    }
}

