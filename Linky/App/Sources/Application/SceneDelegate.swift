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
        setNavigation()
        
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
    
    private func setNavigation() {
        setNavigationBar()
        setBackButtonTitle()
    }
    
    private func setNavigationBar() {
//        let backButtonImage = UIImage(named: "icoArrowLeft")
        
//        UINavigationBar.appearance().backIndicatorImage = backButtonImage
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(named: "code7")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "code7")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor(named: "code2")
    }
    
    private func setBackButtonTitle() {
        UIBarButtonItemAppearance().normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 10)]
    }
}
