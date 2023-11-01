import UIKit

import Core
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
        
        setUserNotificationCenter()
        deviceSizeSetting(window: window)
        setNavigation()
        setSearchBar()
        
        let vc = RootViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        openLockScreen()
    }

    private func openLockScreen() {
        let lock = window?.rootViewController?.presentedViewController as? LockScreenViewController
        
        if UserDefaultsManager.shared.usePassword && lock == nil {
            print(UserDefaultsManager.shared.password)
            let lockScreenVc = LockScreenViewController(type: .normal)

            lockScreenVc.modalPresentationStyle = .overFullScreen

            UIApplication.shared.window?.rootViewController?.present(lockScreenVc, animated: false)
        }
    }
}

extension SceneDelegate {
    private func deviceSizeSetting(window: UIWindow?) {
        UIApplication.safeAreaInset = window?.windowScene?.windows.first?.safeAreaInsets ?? .zero
    }
    
    private func setNavigation() {
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let backButtonImage = UIImage(named: "icoArrowLeft")?
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0))

        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(named: "code7")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "code7")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor(named: "code2")
    }
    
    private func setSearchBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "code2") ?? .white,
            .font: FontManager.shared.pretendard(weight: .medium, size: 15)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setUserNotificationCenter() {
        UNUserNotificationCenter.current().delegate = self
        requestAuthNoti()
    }
    
    private func requestAuthNoti() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().requestAuthorization(options: notiAuthOptions) { (success, error) in
            UserDefaultsManager.shared.isAllowedNotification = success
        }
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.badge, .sound])
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {


            completionHandler()
        }

}
