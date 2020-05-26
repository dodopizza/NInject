import Foundation
import Spry

import NInject

class FakeResolver: Resolver, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case resolveWithTypeAndArguments = "resolve(_:with:)"
        case resolveWithType = "resolve(_:)"
        case resolveWithArguments = "resolve(with:)"
        case resolve = "resolve()"

        case optionalResolveWithTypeAndArguments = "optionalResolve(_:with:)"
        case optionalResolveWithType = "optionalResolve(_:)"
        case optionalResolveWithArguments = "optionalResolve(with:)"
        case optionalResolve = "optionalResolve()"
    }

    init() {
    }

    func resolve<T>(_ type: T.Type) -> T {
        return spryify(arguments: type)
    }

    func resolve<T>(with arguments: Arguments) -> T {
        return spryify(arguments: arguments)
    }

    func resolve<T>() -> T {
        return spryify()
    }

    func resolve<T>(_ type: T.Type, with arguments: Arguments) -> T {
        return spryify(arguments: type, arguments)
    }

    func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T? {
        return spryify(arguments: type, arguments)
    }

    func optionalResolve<T>(_ type: T.Type) -> T? {
        return spryify(arguments: type)
    }

    func optionalResolve<T>(with arguments: Arguments) -> T? {
        return spryify(arguments: arguments)
    }

    func optionalResolve<T>() -> T? {
        return spryify()
    }
}
