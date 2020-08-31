import Foundation

public final
class Container {
    private typealias Storyboardable = (Any, Resolver) -> Void

    private var storages: [String: Storage] = [:]
    private var storyboards: [String: Storyboardable] = [:]
    private let strongRefCycle: Bool

    public init(assemblies: [Assembly],
                storyboardable: Bool = false,
                strongRefCycle: Bool = false) {
        self.strongRefCycle = strongRefCycle

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
        let key = self.key(object, name: nil)
        let storyboard = storyboards[key]

        if strongRefCycle {
            assert(!storyboard.isNil, "\(key) is not registered")
        }

        storyboard?(object, self)
    }

    private func key<T>(_: T, name: String?) -> String {
        let key = String(reflecting: T.self).normalized
        return name.map({ key + "_" + $0 }) ?? key
    }

    private func key(_ obj: Any, name: String?) -> String {
        let key = String(reflecting: type(of: obj)).normalized
        return name.map({ key + "_" + $0 }) ?? key
    }
}

extension Container: Registrator {
    public func registerStoryboardable<T>(_ type: T.Type,
                                          _ entity: @escaping (T, Resolver) -> Void) {
        let key = self.key(type, name: nil)

        if strongRefCycle {
            assert(storyboards[key].isNil, "\(type) is already registered with \(key)")
        }

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
        let key = self.key(type, name: options.name)

        if let found = storages[key] {
            switch found.accessLevel {
            case .final:
                assert(false, "\(type) is already registered with \(key)")
            case .open:
                break
            }
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
    func register<T>(_ type: T.Type, named: String, storage: Storage) {
        let key = self.key(type, name: named)

        if let found = storages[key] {
            switch found.accessLevel {
            case .final:
                assert(false, "\(type) is already registered with \(key)")
            case .open:
                break
            }
        }

        storages[key] = storage
    }

    func register<T>(_ type: T.Type, storage: Storage) {
        let key = self.key(type, name: nil)

        if let found = storages[key] {
            switch found.accessLevel {
            case .final:
                assert(false, "\(type) is already registered with \(key)")
            case .open:
                break
            }
        }

        storages[key] = storage
    }
}

extension Container: Resolver {
    public func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T? {
        return storages[key(type, name: nil)]?.resolve(with: self, arguments: arguments) as? T
    }

    public func optionalResolve<T>(_ type: T.Type, named: String, with arguments: Arguments) -> T? {
        return storages[key(type, name: named)]?.resolve(with: self, arguments: arguments) as? T
    }
}

extension Container /* Storyboardable */ {
    private func makeStoryboardable() {
        if strongRefCycle {
            assert(NSObject.container.isNil, "storyboard handler was registered twice")
        }

        NSObject.container = self
    }
}

private extension String {
    var unwrapped: String {
        if hasPrefix("Swift.Optional") {
            return replacingOccurrences(of: "Swift.Optional<", with: "").replacingOccurrences(of: ">", with: "")
        }
        return self
    }

    var normalized: String {
        return unwrapped.components(separatedBy: ".").filter({ $0 != "Type" && $0 != "Protocol" }).joined(separator: ".")
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
