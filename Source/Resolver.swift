import Foundation

public protocol Resolver {
    typealias Generator<T> = () -> T
    func optionalResolve<T>(_ type: T.Type, with arguments: Arguments, parent: Generator<T>) -> T?
    func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T?
}

// MARK: - strong ref type
public extension Resolver {
    func resolve<T>(_ type: T.Type) -> T {
        resolve(type, with: [])
    }

    func resolve<T>(with arguments: Arguments) -> T {
        resolve(T.self, with: arguments)
    }

    func resolve<T>() -> T {
        resolve(T.self, with: [])
    }

    func resolve<T>(_ type: T.Type, with arguments: Arguments) -> T {
        if let value = optionalResolve(type, with: arguments) {
            return value
        }
        fatalError("can't resolve dependency of <\(type)>")
    }
}

// MARK: - strong ref type & parent
public extension Resolver {
    func resolve<T>(_ type: T.Type, parent: Generator<T>) -> T {
        resolve(type, with: [], parent: parent)
    }

    func resolve<T>(with arguments: Arguments, parent: Generator<T>) -> T {
        resolve(T.self, with: arguments, parent: parent)
    }

    func resolve<T>(parent: Generator<T>) -> T {
        resolve(T.self, with: [], parent: parent)
    }

    func resolve<T>(_ type: T.Type, with arguments: Arguments, parent: Generator<T>) -> T {
        if let value = optionalResolve(type, with: arguments, parent: parent) {
            return value
        }
        fatalError("can't resolve dependency of <\(type)>")
    }
}

// MARK: - optional
public extension Resolver {
    func optionalResolve<T>(_ type: T.Type) -> T? {
        optionalResolve(type, with: [])
    }

    func optionalResolve<T>(with arguments: Arguments) -> T? {
        optionalResolve(T.self, with: arguments)
    }

    func optionalResolve<T>() -> T? {
        optionalResolve(T.self, with: [])
    }
}

// MARK: - optional & parent
public extension Resolver {
    func optionalResolve<T>(_ type: T.Type, parent: Generator<T>) -> T? {
        optionalResolve(type, with: [], parent: parent)
    }

    func optionalResolve<T>(with arguments: Arguments, parent: Generator<T>) -> T? {
        optionalResolve(T.self, with: arguments, parent: parent)
    }

    func optionalResolve<T>(parent: Generator<T>) -> T? {
        optionalResolve(T.self, with: [], parent: parent)
    }
}
