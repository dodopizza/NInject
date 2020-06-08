import Foundation

public struct Options: Equatable {
    public enum AccessLevel: Equatable {
        case final
        case open

        init() {
            self = .final
        }
    }

    public enum EntityKind: Equatable {
        case container
        case weak
        case transient

        init() {
            self = .weak
        }
    }

    public static let `default`: Options = .init(accessLevel: .init(), entityKind: .init())

    public static let container: Options = .init(accessLevel: .init(), entityKind: .container)
    public static let weak:      Options = .init(accessLevel: .init(), entityKind: .weak)
    public static let transient: Options = .init(accessLevel: .init(), entityKind: .transient)

    public static let final: Options = .init(accessLevel: .final, entityKind: .init())
    public static let open: Options = .init(accessLevel: .open, entityKind: .init())

    public let accessLevel: AccessLevel
    public let entityKind: EntityKind

    public init(accessLevel: AccessLevel, entityKind: EntityKind) {
        self.accessLevel = accessLevel
        self.entityKind = entityKind
    }

    public init(_ accessLevel: AccessLevel) {
        self.accessLevel = accessLevel
        self.entityKind = .weak
    }

    public init(_ entityKind: EntityKind) {
        self.accessLevel = .final
        self.entityKind = entityKind
    }
}

public func + (lhs: Options.AccessLevel, rhs: Options.EntityKind) -> Options {
    return .init(accessLevel: lhs, entityKind: rhs)
}

public func + (lhs: Options.EntityKind, rhs: Options.AccessLevel) -> Options {
    return .init(accessLevel: rhs, entityKind: lhs)
}
