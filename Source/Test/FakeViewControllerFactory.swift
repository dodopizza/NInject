import Foundation
import Spry
import Swinject

import NSwinject

class NFakeViewControllerFactory: NViewControllerFactory, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case instantiate = "instantiate(from:bundle:)"
        case createNavigationController = "createNavigationController(from:bundle:)"
    }

    public init() {
    }

    func instantiate<T>(from nibName: String?, bundle: Bundle?) -> T where T: UIViewController {
        return spryify(arguments: T.self, nibName, bundle)
    }

    func createNavigationController<T, N>(from nibName: String?, bundle: Bundle?) -> (navigation: N, root: T) where T: UIViewController, N: UINavigationController {
        return spryify(arguments: T.self, N.self, nibName, bundle)
    }
}
