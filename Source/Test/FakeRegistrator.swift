import Foundation
import Spry

import NInject

class FakeRegistrator: Registrator, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case register = "register(_:kind:entity:)"
        case registerStoryboardable = "registerStoryboardable(_:entity:)"
        case registerViewController = "registerViewController(_:entity:)"
    }

    init() {
    }

    @discardableResult
    func register<T>(_ type: T.Type, kind: EntityKind, _ entity: @escaping (Resolver, Arguments) -> T) -> Forwarding {
        return spryify(arguments: type, kind, entity)
    }

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        return spryify(arguments: type, entity)
    }

    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        return spryify(arguments: type, entity)
    }
}
