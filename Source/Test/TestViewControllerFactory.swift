import Foundation
import Spry

@testable import NInject

public struct NTestViewControllerFactory {
    public static func instantiate<T>(from nibName: String? = nil, bundle: Bundle? = nil, container: Container) -> T where T: UIViewController {
        return Impl.ViewControllerFactory(container: container).instantiate(from: nibName, bundle: bundle)
    }

    public static func createNavigationController<T, N>(from nibName: String? = nil, bundle: Bundle? = nil, container: Container) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return Impl.ViewControllerFactory(container: container).createNavigationController(from: nibName, bundle: bundle)
    }
}
