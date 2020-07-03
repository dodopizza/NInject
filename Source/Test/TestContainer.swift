import Foundation
import NInject
import Spry

@testable import NInject

enum RegistrationInfo: Equatable, SpryEquatable {
    case register(Any.Type, Options)
    case registerStoryboardable(Any.Type)
    case registerViewController(Any.Type)
    case forwarding(to: Any.Type, accessLevel: Options.AccessLevel)
    case forwardingName(to: Any.Type, name: String, accessLevel: Options.AccessLevel)

    static func == (lhs: RegistrationInfo, rhs: RegistrationInfo) -> Bool {
        switch (lhs, rhs) {
        case (.register(let ta, let ka), .register(let tb, let kb)):
            return ta == tb && ka == kb
        case (.registerStoryboardable(let ta), .registerStoryboardable(let tb)):
            return ta == tb
        case (.registerViewController(let ta), .registerViewController(let tb)):
            return ta == tb
        case (.forwarding(let ta, let accessLevelA), .forwarding(let tb, let accessLevelB)):
            return ta == tb && accessLevelA == accessLevelB
        case (.forwardingName(let ta, let nameA, let accessLevelA), .forwardingName(let tb, let nameB, let accessLevelB)):
            return ta == tb && nameA == nameB && accessLevelA == accessLevelB
        case (.register, _),
             (.registerStoryboardable, _),
             (.registerViewController, _),
             (.forwarding, _),
             (.forwardingName, _):
            return false
        }
    }
}

class TestContainer {
    private(set) var registered: [RegistrationInfo] = []
    let real: Container = .init(assemblies: [])

    init() {
    }
}

extension TestContainer: ForwardRegistrator {
    func register<T>(_ type: T.Type, named: String, storage: Storage) {
        registered.append(.forwardingName(to: type, name: named, accessLevel: storage.accessLevel))
        real.register(type, storage: storage)
    }

    func register<T>(_ type: T.Type, storage: Storage) {
        registered.append(.forwarding(to: type, accessLevel: storage.accessLevel))
        real.register(type, storage: storage)
    }
}

extension TestContainer: Registrator {
    @discardableResult
    func register<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver, Arguments) -> T) -> Forwarding {
        registered.append(.register(type, options))
        real.register(type, options: options, entity)
        return Forwarder(container: self, storage: TransientStorage(accessLevel: options.accessLevel, generator: entity))
    }

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerStoryboardable(type))
        return real.registerStoryboardable(type, entity)
    }

    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerViewController(type))
        return real.registerViewController(type, entity)
    }
}
