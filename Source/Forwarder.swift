import Foundation

public protocol Forwarding {
    @discardableResult
    func implements<T>(_ type: T.Type, accessLevel: Options.AccessLevel) -> Self

    @discardableResult
    func implements<T>(_ type: T.Type, named: String, accessLevel: Options.AccessLevel) -> Self

    @discardableResult
    func implements<T>(_ type: T.Type) -> Self

    @discardableResult
    func implements<T>(_ type: T.Type, named: String) -> Self
}

protocol ForwardRegistrator: class {
    func register<T>(_ type: T.Type, storage: Storage)
    func register<T>(_ type: T.Type, named: String, storage: Storage)
}

struct Forwarder: Forwarding {
    private unowned let container: ForwardRegistrator
    private let storage: Storage

    init(container: ForwardRegistrator,
         storage: Storage) {
        self.container = container
        self.storage = storage
    }

    @discardableResult
    func implements<T>(_ type: T.Type, accessLevel: Options.AccessLevel) -> Self {
        container.register(type, storage: ForwardingStorage(storage: storage, accessLevel: accessLevel))
        return self
    }

    @discardableResult
    func implements<T>(_ type: T.Type, named: String, accessLevel: Options.AccessLevel) -> Self {
        container.register(type, named: named, storage: ForwardingStorage(storage: storage, accessLevel: accessLevel))
        return self
    }

    @discardableResult
    func implements<T>(_ type: T.Type) -> Forwarder {
        container.register(type, storage: ForwardingStorage(storage: storage))
        return self
    }

    @discardableResult
    func implements<T>(_ type: T.Type, named: String) -> Forwarder {
        container.register(type, named: named, storage: ForwardingStorage(storage: storage))
        return self
    }
}
