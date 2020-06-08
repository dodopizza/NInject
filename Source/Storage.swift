import Foundation

protocol Storage {
    typealias Entity = Any
    typealias Generator = (Resolver, _ arguments: Arguments) -> Entity

    var accessLevel: Options.AccessLevel { get }
    func resolve(with container: Resolver, arguments: Arguments) -> Entity
}

final
class ContainerStorage: Storage {
    private var entity: Entity?
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator) {
        self.accessLevel = accessLevel
        self.generator = generator
    }

    func resolve(with container: Resolver, arguments: Arguments) -> Entity {
        if let entity = entity {
            return entity
        }

        let entity = generator(container, arguments)
        self.entity = entity
        return entity
    }
}

final
class WeakStorage: Storage {
    private var entity: () -> Entity? = { nil }
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator) {
        self.accessLevel = accessLevel
        self.generator = generator
    }

    func resolve(with container: Resolver, arguments: Arguments) -> Entity {
        if let entity = entity() {
            return entity
        }

        let entity = generator(container, arguments) as AnyObject
        self.entity = { [weak entity] in return entity }
        return entity
    }
}

final
class TransientStorage: Storage {
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator) {
        self.accessLevel = accessLevel
        self.generator = generator
    }

    func resolve(with container: Resolver, arguments: Arguments) -> Entity {
        generator(container, arguments)
    }
}
