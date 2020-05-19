import Foundation

public protocol Registrator {
    @discardableResult
    func register<T>(_ type: T.Type, kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void)
}

public extension Registrator {
    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registerStoryboardable(type, entity)
    }
}

public extension Registrator {
    // MARK: resolver & arguments
    @discardableResult
    func register<T>(kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(T.self, kind: kind, entity)
    }

    @discardableResult
    func register<T>(_ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(T.self, kind: .default, entity)
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(type, kind: .default, entity)
    }

    @discardableResult
    func register<T>(kind: EntityKind = .default, _ entity: @escaping (_ arguments: Arguments) -> T) -> Forwarding {
        register(kind: kind, { _, args in entity(args) })
    }

    @discardableResult
    func register<T>(_ entity: @escaping (_ arguments: Arguments) -> T) -> Forwarding {
        register(kind: .default, { _, args in entity(args) })
    }

    // MARK: resolver
    @discardableResult
    func register<T>(kind: EntityKind, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(T.self, kind: kind, { r, _ in entity(r) })
    }

    @discardableResult
    func register<T>(_ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(T.self, kind: .default, { r, _ in entity(r) })
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(type, kind: .default, { r, _ in entity(r) })
    }

    // MARK: -
    @discardableResult
    func register<T>(kind: EntityKind = .default, _ entity: @escaping () -> T) -> Forwarding {
        register(kind: kind, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ entity: @escaping () -> T) -> Forwarding {
        register(kind: .default, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ type: T.Type, kind: EntityKind = .default, _ entity: @escaping () -> T) -> Forwarding {
        register(kind: kind, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping () -> T) -> Forwarding {
        register(kind: .default, { _, _ in entity() })
    }
}
