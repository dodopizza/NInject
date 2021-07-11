import Foundation
import UIKit
import NInject
import NSpry

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

    var type: Any.Type {
        switch self {
        case .register(let t, _),
             .registerStoryboardable(let t),
             .registerViewController(let t),
             .forwarding(to: let t, accessLevel: _),
             .forwardingName(to: let t, name: _, accessLevel: _):
            return t
        }
    }
}

class TestContainer {
    let registered: [RegistrationInfo]

    init(assemblies: [Assembly]) {
        let testRegistrator = TestRegistrator()
        for assemby in assemblies {
            assemby.assemble(with: testRegistrator)
        }

        self.registered = testRegistrator.registered
    }
}

private class TestRegistrator {
    private(set) var registered: [RegistrationInfo] = []
}

extension TestRegistrator: ForwardRegistrator {
    func register<T>(_ type: T.Type, named: String, storage: Storage) {
        registered.append(.forwardingName(to: type, name: named, accessLevel: storage.accessLevel))
    }

    func register<T>(_ type: T.Type, storage: Storage) {
        registered.append(.forwarding(to: type, accessLevel: storage.accessLevel))
    }
}

extension TestRegistrator: Registrator {
    @discardableResult
    func register<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver, Arguments) -> T) -> Forwarding {
        registered.append(.register(type, options))
        return Forwarder(container: self, storage: TransientStorage(accessLevel: options.accessLevel, generator: entity))
    }

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerStoryboardable(type))
    }

    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registered.append(.registerViewController(type))
    }
}
