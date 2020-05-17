import Foundation

public protocol Registrator {
    func register<T>(_ type: T.Type, kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T)
    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void)
}

public extension Registrator {
    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registerStoryboardable(type, entity)
    }
}

public extension Registrator {
    // MARK: resolver & arguments
    func register<T>(kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(T.self, kind: kind, entity)
    }

    func register<T>(_ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(T.self, kind: .default, entity)
    }

    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(type, kind: .default, entity)
    }

    func register<T>(kind: EntityKind = .default, _ entity: @escaping (_ arguments: Arguments) -> T) {
        register(kind: kind, { _, args in entity(args) })
    }

    func register<T>(_ entity: @escaping (_ arguments: Arguments) -> T) {
        register(kind: .default, { _, args in entity(args) })
    }

    // MARK: resolver
    func register<T>(kind: EntityKind, _ entity: @escaping (Resolver) -> T) {
        register(T.self, kind: kind, { r, _ in entity(r) })
    }

    func register<T>(_ entity: @escaping (Resolver) -> T) {
        register(T.self, kind: .default, { r, _ in entity(r) })
    }

    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver) -> T) {
        register(type, kind: .default, { r, _ in entity(r) })
    }

    // MARK: -
    func register<T>(kind: EntityKind = .default, _ entity: @escaping () -> T) {
        register(kind: kind, { _, _ in entity() })
    }

    func register<T>(_ entity: @escaping () -> T) {
        register(kind: .default, { _, _ in entity() })
    }

    func register<T>(_ type: T.Type, kind: EntityKind = .default, _ entity: @escaping () -> T) {
        register(kind: kind, { _, _ in entity() })
    }

    func register<T>(_ type: T.Type, _ entity: @escaping () -> T) {
        register(kind: .default, { _, _ in entity() })
    }
}
