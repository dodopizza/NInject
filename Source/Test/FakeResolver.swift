import Foundation
import Spry

import NInject

class FakeResolver: Resolver, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case optionalResolve = "optionalResolve()"
        case optionalResolveWithType = "optionalResolve(type:)"
        case optionalResolveWithTypeAndArguments = "optionalResolve(type:arguments:)"

        case resolve = "resolve()"
        case resolveWithType = "resolve(type:)"
        case resolveWithTypeAndArguments = "resolve(type:arguments:)"
    }

    init() {
    }

    func optionalResolve<T>() -> T? {
        return spryify()
    }

    func optionalResolve<T>(_ type: T.Type) -> T? {
        return spryify(arguments: type)
    }

    func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T? {
        return spryify(arguments: type, arguments)
    }

    func resolve<T>() -> T {
        return spryify()
    }

    func resolve<T>(_ type: T.Type) -> T {
        return spryify(arguments: type)
    }

    func resolve<T>(_ type: T.Type, with arguments: Arguments) -> T {
        return spryify(arguments: type, arguments)
    }
}
