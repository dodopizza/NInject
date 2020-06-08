import Foundation

public final
class Container {
    private typealias Storyboardable = (Any, Resolver) -> Void

    private var storages: [String: Storage] = [:]
    private var storyboards: [String: Storyboardable] = [:]

    public init(assemblies: [Assembly],
                storyboardable: Bool = false) {
        assemblies.forEach({ $0.assemble(with: self) })

        if storyboardable {
            makeStoryboardable()
        }

        register(ViewControllerFactory.self) { [unowned self] _, _ in
            Impl.ViewControllerFactory(container: self)
        }
    }

    deinit {
        if NSObject.container === self {
            NSObject.container = nil
        }
    }

    public convenience init(assemblies: Assembly..., storyboardable: Bool = false) {
        self.init(assemblies: assemblies, storyboardable: storyboardable)
    }

    func resolveStoryboardable(_ object: Any) {
        let key = self.key(object)
        let storyboard = storyboards[key]

        assert(!storyboard.isNil, "\(key) is not registered")
        storyboard?(object, self)
    }

    private func key<T>(_: T) -> String {
        let key = String(reflecting: T.self).normalized
        return key
    }

    private func key(_ obj: Any) -> String {
        let key = String(reflecting: type(of: obj)).normalized
        return key
    }
}

extension Container: Registrator {
    public func registerStoryboardable<T>(_ type: T.Type,
                                          _ entity: @escaping (T, Resolver) -> Void) {
        let key = self.key(type)
        assert(storyboards[key].isNil, "\(type) is already registered")
        storyboards[key] = { c, r in
            if let c = c as? T {
                entity(c, r)
            }
        }
    }

    @discardableResult
    public func register<T>(_ type: T.Type,
                            options: Options = .default,
                            _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) -> Forwarding {
        let key = self.key(type)

        switch storages[key]?.accessLevel {
        case .final?:
            assert(storages[key].isNil, "\(type) is already registered")
        case .open?,
             .none:
            break
        }

        let storage: Storage
        let accessLevel = options.accessLevel
        switch options.entityKind {
        case .container:
            storage = ContainerStorage(accessLevel: accessLevel, generator: entity)
        case .transient:
            storage = TransientStorage(accessLevel: accessLevel, generator: entity)
        case .weak:
            storage = WeakStorage(accessLevel: accessLevel, generator: entity)
        }

        storages[key] = storage
        return Forwarder(container: self, storage: storage)
    }
}

extension Container: ForwardRegistrator {
    func register<T>(_ type: T.Type, storage: Storage) {
        let key = self.key(type)
        assert(storages[key].isNil, "\(type) is already registered")
        storages[key] = storage
    }
}

extension Container: Resolver {
    public func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T? {
        return storages[key(type)]?.resolve(with: self, arguments: arguments) as? T
    }
}

extension Container /* Storyboardable */ {
    private func makeStoryboardable() {
        assert(NSObject.container.isNil, "storyboard handler was registered twice")
        NSObject.container = self
    }
}

private extension String {
    var normalized: String {
        components(separatedBy: ".").filter({ $0 != "Type" && $0 != "Protocol" }).joined(separator: ".")
    }
}

private extension Optional {
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
}
