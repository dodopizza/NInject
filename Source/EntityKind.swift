import Foundation

public enum EntityKind {
    case container
    case weak
    case transient

    public init() {
        self = .weak
    }
}
