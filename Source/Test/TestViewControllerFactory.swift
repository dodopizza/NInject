import Foundation
import Spry
import Swinject

@testable import NSwinject

public struct NTestViewControllerFactory {
    public static func instantiate<T>(from nibName: String? = nil, bundle: Bundle? = nil, container: Container) -> T where T: UIViewController {
        return NViewControllerFactoryImpl(container: container).instantiate(from: nibName, bundle: bundle)
    }

    public static func createNavigationController<T, N>(from nibName: String? = nil, bundle: Bundle? = nil, container: Container) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return NViewControllerFactoryImpl(container: container).createNavigationController(from: nibName, bundle: bundle)
    }
}
