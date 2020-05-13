import Foundation

public enum EntityKind: Equatable {
    case container
    case weak
    case transient

    public init() {
        self = .default
    }

    public static var `default`: EntityKind {
        .weak
    }
}
