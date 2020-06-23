import Foundation
import Spry

import NInject

class FakeForwarding: Forwarding, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case implements = "implements(_:)"
        case implementsNamed = "implements(_:named:)"
    }

    init() {
    }

    func implements<T>(_ type: T.Type) -> Self {
        return spryify(arguments: type)
    }

    func implements<T>(_ type: T.Type, named: String) -> Self {
        return spryify(arguments: type, named)
    }
}
