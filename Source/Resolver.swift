import Foundation

public protocol Resolver {
    func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T?
    func optionalResolve<T>(_ type: T.Type, named: String, with arguments: Arguments) -> T?
}

// MARK: - strong ref type

public extension Resolver {
    func optionalResolve<T>(_ type: T.Type, with arguments: [Any]) -> T? {
        optionalResolve(type, with: Arguments(arguments))
    }

    func optionalResolve<T>(_ type: T.Type, with arguments: Any...) -> T? {
        optionalResolve(type, with: Arguments(arguments))
    }

    func optionalResolve<T>(_ type: T.Type, named: String, with arguments: [Any]) -> T? {
        optionalResolve(type, named: named, with: Arguments(arguments))
    }

    func optionalResolve<T>(_ type: T.Type, named: String, with arguments: Any...) -> T? {
        optionalResolve(type, named: named, with: Arguments(arguments))
    }

    func resolve<T>(_ type: T.Type) -> T {
        resolve(type, with: [])
    }

    func resolve<T>(with arguments: Arguments) -> T {
        resolve(T.self, with: arguments)
    }

    func resolve<T>(with arguments: [Any]) -> T {
        resolve(with: Arguments(arguments))
    }

    func resolve<T>(with arguments: Any...) -> T {
        resolve(with: Arguments(arguments))
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

    func resolve<T>(_ type: T.Type, with arguments: [Any]) -> T {
        resolve(type, with: Arguments(arguments))
    }

    func resolve<T>(_ type: T.Type, with arguments: Any...) -> T {
        resolve(type, with: Arguments(arguments))
    }

    func resolve<T>(_ type: T.Type, named: String) -> T {
        resolve(type, named: named, with: [])
    }

    func resolve<T>(named: String, with arguments: Arguments) -> T {
        resolve(T.self, named: named, with: arguments)
    }

    func resolve<T>(named: String, with arguments: [Any]) -> T {
        resolve(named: named, with: Arguments(arguments))
    }

    func resolve<T>(named: String, with arguments: Any...) -> T {
        resolve(named: named, with: Arguments(arguments))
    }

    func resolve<T>(named: String) -> T {
        resolve(T.self, named: named, with: [])
    }

    func resolve<T>(_ type: T.Type, named: String, with arguments: Arguments) -> T {
        if let value = optionalResolve(type, named: named, with: arguments) {
            return value
        }
        fatalError("can't resolve dependency of <\(type)>")
    }

    func resolve<T>(_ type: T.Type, named: String, with arguments: [Any]) -> T {
        resolve(type, named: named, with: Arguments(arguments))
    }

    func resolve<T>(_ type: T.Type, named: String, with arguments: Any...) -> T {
        resolve(type, named: named, with: Arguments(arguments))
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

    func optionalResolve<T>(with arguments: [Any]) -> T? {
        optionalResolve(T.self, with: Arguments(arguments))
    }

    func optionalResolve<T>(with arguments: Any...) -> T? {
        optionalResolve(T.self, with: Arguments(arguments))
    }

    func optionalResolve<T>() -> T? {
        optionalResolve(T.self, with: [])
    }

    func optionalResolve<T>(_ type: T.Type, named: String) -> T? {
        optionalResolve(type, named: named, with: [])
    }

    func optionalResolve<T>(named: String, with arguments: Arguments) -> T? {
        optionalResolve(T.self, named: named, with: arguments)
    }

    func optionalResolve<T>(named: String, with arguments: [Any]) -> T? {
        optionalResolve(T.self, named: named, with: Arguments(arguments))
    }

    func optionalResolve<T>(named: String, with arguments: Any...) -> T? {
        optionalResolve(T.self, named: named, with: Arguments(arguments))
    }

    func optionalResolve<T>(named: String) -> T? {
        optionalResolve(T.self, named: named, with: [])
    }
}
