import Foundation

public struct Arguments: ExpressibleByArrayLiteral {
    private let elements: [Any]

    public init(arrayLiteral elements: Any...) {
        self.elements = elements
    }

    public func resolve<T>(_ type: T.Type, at index: Int) -> T {
        elements[index] as! T
    }

    public func resolve<T>(at index: Int) -> T {
        resolve(T.self, at: index)
    }

    public subscript<T>(index: Int) -> T {
        elements[index] as! T
    }
}
