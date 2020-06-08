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
    }

    public static let `default`: Options = .init(accessLevel: .init(), entityKind: .weak)

    public static let container: Options = .init(accessLevel: .init(), entityKind: .container)
    public static let weak:      Options = .init(accessLevel: .init(), entityKind: .weak)
    public static let transient: Options = .init(accessLevel: .init(), entityKind: .transient)

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
