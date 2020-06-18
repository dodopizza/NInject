import Foundation

public protocol Registrator {
    @discardableResult
    func register<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding

    func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void)

    typealias ParentGenerator<T> = () -> T
    func override<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver, _ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding
}

public extension Registrator {
    func registerViewController<T: UIViewController>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        registerStoryboardable(type, entity)
    }

    func registerViewController<T>(_ type: T.Type) {
        registerStoryboardable(type, { _, _ in })
    }

    func registerStoryboardable<T>(_ type: T.Type) {
        registerStoryboardable(type, { _, _ in })
    }
}

public extension Registrator {
    // MARK: resolver & arguments
    @discardableResult
    func register<T>(options: Options, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(T.self, options: options, entity)
    }

    @discardableResult
    func register<T>(_ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(T.self, options: .default, entity)
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        register(type, options: .default, entity)
    }

    // MARK: arguments
    @discardableResult
    func register<T>(options: Options, _ entity: @escaping (_ arguments: Arguments) -> T) -> Forwarding {
        register(options: options, { _, args in entity(args) })
    }

    @discardableResult
    func register<T>(_ entity: @escaping (_ arguments: Arguments) -> T) -> Forwarding {
        register(options: .default, { _, args in entity(args) })
    }

    // MARK: resolver
    @discardableResult
    func register<T>(options: Options, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(T.self, options: options, { r, _ in entity(r) })
    }

    @discardableResult
    func register<T>(_ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(T.self, options: .default, { r, _ in entity(r) })
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(type, options: .default, { r, _ in entity(r) })
    }

    @discardableResult
    func register<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        register(type, options: options, { r, _ in entity(r) })
    }

    // MARK: -
    @discardableResult
    func register<T>(options: Options, _ entity: @escaping () -> T) -> Forwarding {
        register(options: options, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ entity: @escaping () -> T) -> Forwarding {
        register(options: .default, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ type: T.Type, options: Options, _ entity: @escaping () -> T) -> Forwarding {
        register(options: options, { _, _ in entity() })
    }

    @discardableResult
    func register<T>(_ type: T.Type, _ entity: @escaping () -> T) -> Forwarding {
        register(options: .default, { _, _ in entity() })
    }
}

public extension Registrator {
    // MARK: resolver & arguments & parent
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping (Resolver, _ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(T.self, options: options, entity)
    }

    @discardableResult
    func override<T>(_ entity: @escaping (Resolver, _ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(T.self, options: .default, entity)
    }

    @discardableResult
    func override<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(type, options: .default, entity)
    }

    // MARK: arguments & parent
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping (_ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: options, { _, args, parent in entity(args, parent) })
    }

    @discardableResult
    func override<T>(_ entity: @escaping (_ arguments: Arguments, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: .default, { _, args, parent in entity(args, parent) })
    }

    // MARK: resolver & parent
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping (Resolver, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(T.self, options: options, { r, _, parent in entity(r, parent) })
    }

    @discardableResult
    func override<T>(_ entity: @escaping (Resolver, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(T.self, options: .default, { r, _, parent in entity(r, parent) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, _ entity: @escaping (Resolver, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(type, options: .default, { r, _, parent in entity(r, parent) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver, _ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(type, options: options, { r, _, parent in entity(r, parent) })
    }

    // MARK: resolver
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        override(T.self, options: options, { r, _, _ in entity(r) })
    }

    @discardableResult
    func override<T>(_ entity: @escaping (Resolver) -> T) -> Forwarding {
        override(T.self, options: .default, { r, _, _ in entity(r) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        override(type, options: .default, { r, _, _ in entity(r) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, options: Options, _ entity: @escaping (Resolver) -> T) -> Forwarding {
        override(type, options: options, { r, _, _ in entity(r) })
    }

    // MARK: parent
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping (_ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: options, { _, _, parent in entity(parent) })
    }

    @discardableResult
    func override<T>(_ entity: @escaping (_ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: .default, { _, _, parent in entity(parent) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, options: Options, _ entity: @escaping (_ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: options, { _, _, parent in entity(parent) })
    }

    @discardableResult
    func override<T>(_ type: T.Type, _ entity: @escaping (_ parent: ParentGenerator<T>) -> T) -> Forwarding {
        override(options: .default, { _, _, parent in entity(parent) })
    }

    // MARK: parent
    @discardableResult
    func override<T>(options: Options, _ entity: @escaping () -> T) -> Forwarding {
        override(options: options, { _, _, _ in entity() })
    }

    @discardableResult
    func override<T>(_ entity: @escaping () -> T) -> Forwarding {
        override(options: .default, { _, _, _ in entity() })
    }

    @discardableResult
    func override<T>(_ type: T.Type, options: Options, _ entity: @escaping () -> T) -> Forwarding {
        override(options: options, { _, _, _ in entity() })
    }

    @discardableResult
    func override<T>(_ type: T.Type, _ entity: @escaping () -> T) -> Forwarding {
        override(options: .default, { _, _, _ in entity() })
    }
}
