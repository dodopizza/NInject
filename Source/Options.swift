import Foundation

public struct Options: Equatable {
    public enum AccessLevel: Equatable {
        case final
        case open

        init() {
            self = .final
        }

        public static let forwarding: AccessLevel = .final
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

    public static func named(_ name: String) -> Options {
        .init(accessLevel: .init(), entityKind: .init(), name: name)
    }

    public let accessLevel: AccessLevel
    public let entityKind: EntityKind
    public let name: String?

    public init(accessLevel: AccessLevel = .final,
                entityKind: EntityKind = .weak,
                name: String? = nil) {
        self.accessLevel = accessLevel
        self.entityKind = entityKind
        self.name = name
    }
}

public func + (lhs: Options.AccessLevel, rhs: Options.EntityKind) -> Options {
    return .init(accessLevel: lhs, entityKind: rhs)
}

public func + (lhs: Options.EntityKind, rhs: Options.AccessLevel) -> Options {
    return .init(accessLevel: rhs, entityKind: lhs)
}

public func + (lhs: Options, rhs: String) -> Options {
    return .init(accessLevel: lhs.accessLevel, entityKind: lhs.entityKind, name: rhs)
}
