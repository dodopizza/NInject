import Foundation

protocol Storage {
    typealias Entity = Any
    typealias Generator = (Resolver, _ arguments: Arguments) -> Entity

    var accessLevel: Options.AccessLevel { get }
    func resolve(with resolver: Resolver, arguments: Arguments) -> Entity
}

final class ForwardingStorage: Storage {
    let accessLevel: Options.AccessLevel
    private let storage: Storage

    init(storage: Storage,
         accessLevel: Options.AccessLevel? = nil) {
        self.storage = storage
        self.accessLevel = accessLevel ?? .forwarding
    }

    func resolve(with resolver: Resolver, arguments: Arguments) -> Entity {
        return storage.resolve(with: resolver, arguments: arguments)
    }
}

final class ContainerStorage: Storage {
    private var entity: Entity?
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator,
         entity: Entity? = nil) {
        self.accessLevel = accessLevel
        self.generator = generator
    }

    func resolve(with resolver: Resolver, arguments: Arguments) -> Entity {
        if let entity = entity {
            return entity
        }

        let entity = generator(resolver, arguments)
        self.entity = entity
        return entity
    }
}

final class WeakStorage: Storage {
    private var entity: () -> Entity?
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator,
         entity: @escaping () -> Entity? = { nil }) {
        self.accessLevel = accessLevel
        self.generator = generator
        self.entity = entity
    }

    func resolve(with resolver: Resolver, arguments: Arguments) -> Entity {
        if let entity = entity() {
            return entity
        }

        let entity = generator(resolver, arguments)
        if #available(iOS 13, *) {
            let wrapped = entity as AnyObject
            self.entity = { [weak wrapped] in
                return wrapped
            }
        } else {
            // iOS 12.4 has crash when eventually resolving code `entity as AnyObject` and return `nil`
            // while registered object is `struct` (not class)
            let wrapped = NSValue(nonretainedObject: entity)
            self.entity = { [weak wrapped] in
                var pointer: Entity?
                wrapped?.getValue(&pointer)
                return pointer
            }
        }

        return entity
    }
}

final class TransientStorage: Storage {
    private let generator: Generator
    let accessLevel: Options.AccessLevel

    init(accessLevel: Options.AccessLevel,
         generator: @escaping Generator) {
        self.accessLevel = accessLevel
        self.generator = generator
    }

    func resolve(with resolver: Resolver, arguments: Arguments) -> Entity {
        generator(resolver, arguments)
    }
}
