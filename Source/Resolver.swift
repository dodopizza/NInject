import Foundation

public protocol Resolver {
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

// MARK: - optional
public extension Resolver {
    func optionalResolve<T>(_ type: T.Type) -> T {
        resolve(type, with: [])
    }

    func optionalResolve<T>(with arguments: Arguments) -> T {
        resolve(T.self, with: arguments)
    }

    func optionalResolve<T>() -> T {
        resolve(T.self, with: [])
    }
}
