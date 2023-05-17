import UIKit
import Features

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        deviceSizeSetting(window: window)
        
        let vc = RootViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
    private func deviceSizeSetting(window: UIWindow?) {
        UIApplication.safeAreaInset = window?.windowScene?.windows.first?.safeAreaInsets ?? .zero
    }
}
