import Foundation
import NInject
import Spry

enum RegistrationInfo: Equatable, SpryEquatable {
    case register(Any.Type, EntityKind)
    case registerStoryboardable(Any.Type)
    case registerViewController(Any.Type)

    static func == (lhs: RegistrationInfo, rhs: RegistrationInfo) -> Bool {
        switch (lhs, rhs) {
        case (.register(let ta, let ka), .register(let tb, let kb)):
            return ta == tb && ka == kb
        case (.registerStoryboardable(let ta), .registerStoryboardable(let tb)):
            return ta == tb
        case (.registerViewController(let ta), .registerViewController(let tb)):
            return ta == tb
        case (register, _),
             (registerStoryboardable, _),
             (registerViewController, _):
            return false
        }
    }
}

class TestRegistrator: Registrator {
    private(set) var registered: [RegistrationInfo] = []

    init() {
    }

    func register<T>(_ type: T.Type, kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        registered.append(.register(type, kind))
    }

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerStoryboardable(type))
    }

    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerViewController(type))
    }
}
