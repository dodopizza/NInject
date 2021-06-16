import Foundation

public protocol Assembly {
    var id: String { get }
    var dependencies: [Assembly] { get }

    func assemble(with registrator: Registrator)
}

public extension Assembly {
    var id: String {
        return String(reflecting: type(of: self))
    }

    var dependencies: [Assembly] {
        return []
    }
}
