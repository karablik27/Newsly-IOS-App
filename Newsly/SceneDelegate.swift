import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemTeal,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance  = navBarAppearance
        UINavigationBar.appearance().tintColor = .systemTeal

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let root = NewsRouter.assembleModule()
        window.rootViewController = root
        self.window = window
        window.makeKeyAndVisible()
    }

}

