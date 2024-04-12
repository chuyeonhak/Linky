import UIKit
import WidgetKit

import Core
import Features

import Firebase
import FirebaseCore
import FirebaseRemoteConfig

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        sleep(1)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        setFirebase()
        setUserNotificationCenter()
        deviceSizeSetting(window: window)
        setNavigation()
        setSearchBar()
        
        let vc = RootViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        widgetCheck(context: connectionOptions.urlContexts.first)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if UpdateManager.shared.shouldUpdate { openUpdateAlert() }
        else {
            openLockScreen()
            requestAuthNoti()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) { WidgetCenter.shared.reloadAllTimelines() }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        widgetCheck(context: URLContexts.first)
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
        UIBarButtonItem
            .appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setFirebase() {
        FirebaseApp.configure()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings().then { $0.minimumFetchInterval = 0 }
        
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { status, error in
            switch status {
            case .success:
                remoteConfig.activate { isChanged, error in
                    self.setUserDefaultFromRemoteConfig(remoteConfig)
                }
            default: break
            }
        }
    }
    
    private func setUserNotificationCenter() {
        UNUserNotificationCenter.current().delegate = self
        requestAuthNoti()
    }
    
    private func openLockScreen() {
        let lock = window?.rootViewController?.presentedViewController as? LockScreenViewController
        let rootViewController = window?.rootViewController as? RootViewController
        
        if UserDefaultsManager.shared.usePassword && lock == nil {
            print("my password = \(UserDefaultsManager.shared.password)")
            let lockScreenVc = LockScreenViewController(type: .normal)

            lockScreenVc.modalPresentationStyle = .overFullScreen
            lockScreenVc.unlockAction = { _ in rootViewController?.moveToTimeLineViewController() }

            UIApplication.shared.window?.rootViewController?.present(lockScreenVc, animated: false)
        }
    }
    
    private func requestAuthNoti() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().requestAuthorization(options: notiAuthOptions) { (success, error) in
            let notiManager = UserNotiManager.shared
            let defaultManager = UserDefaultsManager.shared
            
            UserDefaultsManager.shared.isAllowedNotification = success
            defaultManager.useNotification ? notiManager.saveNoti(): notiManager.deleteAllNotifications()
        }
    }
    
    private func openUpdateAlert() {
        let blockView = UIView().then { $0.backgroundColor = .main }
        window?.rootViewController?.view.addSubview(blockView)
        blockView.snp.makeConstraints { $0.edges.equalToSuperview() }
        window?.rootViewController?.presentAlertController(
            style: .alert,
            title: I18N.updateTitle,
            options: (title: I18N.updateMessage, style: .default),
            animated: false) { _ in UpdateManager.shared.openAppStore() }
    }
    
    private func setUserDefaultFromRemoteConfig(_ config: RemoteConfig) {
        let code = getConfigCode()
        
        UserDefaultsManager.shared.notice = config[code].string
        UserDefaultsManager.shared.errorURL = config[RemoteConfigKey.errorUrl.stringValue].string
        UserDefaultsManager.shared.wantURL = config[RemoteConfigKey.wantUrl.stringValue].string
        UserDefaultsManager.shared.etcURL = config[RemoteConfigKey.etcUrl.stringValue].string
    }
    
    private func getConfigCode() -> String {
        let languageCode = Locale.current.languageCode ?? ""
        
        return if languageCode.isKorean { "notice" }
        else if languageCode.isJapan { "noticeJapan" }
        else { "noticeEnglish" }
    }
    
    private func widgetCheck(context: UIOpenURLContext?) {
        guard let context,
              case let linkList = UserDefaultsManager.shared.linkList,
              let link = linkList.first (where: { $0.url == context.url.absoluteString }),
              let rootViewController = window?.rootViewController as? RootViewController
        else { return }
        
        UserDefaultsManager.shared.widgetLink = link
        if !UserDefaultsManager.shared.usePassword {
            rootViewController.moveToTimeLineViewController()
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

extension RemoteConfigValue {
    var string: String { stringValue ?? "" }
}

enum RemoteConfigKey {
    case notice
    case noticeJapan
    case noticeEnglish
    case errorUrl
    case wantUrl
    case etcUrl
    
    var stringValue: String {
        switch self {
        case .notice: "notice"
        case .noticeJapan: "noticeJapan"
        case .noticeEnglish: "noticeEnglish"
        case .errorUrl: "errorUrl"
        case .wantUrl: "wantUrl"
        case .etcUrl: "etcUrl"
        }
    }
}
