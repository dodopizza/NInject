import Foundation
import Spry

import NInject

class FakeForwarding: Forwarding, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }

    enum Function: String, StringRepresentable {
        case implements = "implements(_:)"
    }

    init() {
    }

    func implements<T>(_ type: T.Type) -> Self {
        return spryify(arguments: type)
    }
}
