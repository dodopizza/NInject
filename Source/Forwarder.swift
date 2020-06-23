import Foundation

public protocol Forwarding {
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
    func implements<K>(_ type: K.Type) -> Self {
        container.register(type, storage: storage)
        return self
    }

    @discardableResult
    func implements<K>(_ type: K.Type, named: String) -> Self {
        container.register(type, named: named, storage: storage)
        return self
    }
}
