import Foundation

public protocol Registrator {
    func register<T>(_ type: T.Type, kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T)

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void)
    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void)
}

public extension Registrator {
    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registerStoryboardable(type, entity)
    }
}

public extension Registrator {
    func register<T>(kind: EntityKind, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(T.self, kind: kind, entity)
    }

    func register<T>(_ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(T.self, kind: .init(), entity)
    }

    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        register(type, kind: .init(), entity)
    }

    func register<T>(kind: EntityKind = .init(), _ entity: @escaping (_ arguments: Arguments) -> T) {
        register(kind: kind, { _, args in entity(args) })
    }

    func register<T>(_ entity: @escaping (_ arguments: Arguments) -> T) {
        register(kind: .init(), { _, args in entity(args) })
    }

    func register<T>(kind: EntityKind = .init(), _ entity: @escaping () -> T) {
        register(kind: kind, { _, _ in entity() })
    }

    func register<T>(_ entity: @escaping () -> T) {
        register(kind: .init(), { _, _ in entity() })
    }

    func register<T>(_ type: T.Type, kind: EntityKind = .init(), _ entity: @escaping () -> T) {
        register(kind: kind, { _, _ in entity() })
    }

    func register<T>(_ type: T.Type, _ entity: @escaping () -> T) {
        register(kind: .init(), { _, _ in entity() })
    }
}
