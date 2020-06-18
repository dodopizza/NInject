import Foundation

protocol Storage {
    typealias Entity = Any
    typealias ParentGenerator = (arguments: Arguments) -> Entity
    typealias Generator = (Resolver, _ arguments: Arguments, _ parent: ParentGenerator?) -> Entity

    var accessLevel: Options.AccessLevel { get }
    func resolve(with container: Resolver, arguments: Arguments) -> Entity
}

final
class ContainerStorage: Storage {
    private var entity: Entity?
    private let generator: Generator
    private let parent: Storage?

    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator,
         parent: Storage? = nil) {
        self.accessLevel = accessLevel
        self.generator = generator
        self.parent = parent
    }

    func resolve(with container: Resolver, arguments: Arguments) -> Entity {
        if let entity = entity {
            return entity
        }

        let parentGenerator: ParentGenerator = { arguments in
            if let parent = parent {
                return parent.resolve(with: container, arguments: arguments)
            }
        }
        let entity = generator(container, arguments, parentGenerator)
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

        let entity = generator(container, arguments, parent) as AnyObject
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
        generator(container, arguments, parent)
    }
}
