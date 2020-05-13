import UIKit
import Swinject
import SwinjectStoryboard

public protocol NViewControllerFactory {
    func instantiate<T: UIViewController>(from nibName: String?, bundle: Bundle?) -> T
    func createNavigationController<T, N>(from nibName: String?, bundle: Bundle?) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController
}

class NViewControllerFactoryImpl: NViewControllerFactory {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func instantiate<T: UIViewController>(from nibName: String? = nil, bundle: Bundle? = nil) -> T {
        let klass: String = nibName ?? String(describing: T.self)
        let storyboard = SwinjectStoryboard.create(name: klass, bundle: bundle ?? Bundle(for: T.self), container: container)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateInitialViewController() as! T
    }

    func createNavigationController<T, N>(from nibName: String?, bundle: Bundle?) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        let root: T = instantiate(from: nibName, bundle: bundle)
        return (N(rootViewController: root), root)
    }
}

extension NViewControllerFactory {
    public func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        return instantiate(from: nil, bundle: nil)
    }

    public func instantiate<T: UIViewController>() -> T {
        return instantiate(from: nil, bundle: nil)
    }

    public func instantiate<T: UIViewController>(from nibName: String?) -> T {
        return instantiate(from: nibName, bundle: nil)
    }

    public func instantiate<T: UIViewController>(bundle: Bundle?) -> T {
        return instantiate(from: nil, bundle: bundle)
    }

    public func createNavigationController<T, N>(_: T.Type) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return createNavigationController(from: nil, bundle: nil)
    }

    public func createNavigationController<T, N>() -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return createNavigationController(from: nil, bundle: nil)
    }

    public func createNavigationController<T, N>(bundle: Bundle?) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return createNavigationController(from: nil, bundle: bundle)
    }

    public func createNavigationController<T, N>(from nibName: String?) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return createNavigationController(from: nibName, bundle: nil)
    }
}
