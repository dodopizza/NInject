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
    }

    public convenience init(assemblies: Assembly..., storyboardable: Bool = false) {
        self.init(assemblies: assemblies, storyboardable: storyboardable)
    }

    func resolveStoryboardable(_ object: NSObject) {
        let key = self.key(object)
        let storyboard = storyboards[key]

        assert(storyboard.isNil, "\(key) is not registered")
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
    public func registerStoryboardable<T>(_ type: T.Type, _ entity: @escaping (T, Resolver) -> Void) {
        let key = self.key(type)
        assert(storyboards[key].isNil, "\(type) is already registered")
        storyboards[key] = { c, r in
            if let c = c as? T {
                entity(c, r)
            }
        }
    }

    public func register<T>(_ type: T.Type, kind: EntityKind = .init(), _ entity: @escaping (Resolver, _ arguments: Arguments) -> T) {
        let key = self.key(type)
        print(key)
        assert(storages[key].isNil, "\(type) is already registered")

        switch kind {
        case .container:
            storages[key] = ContainerStorage(generator: entity)
        case .transient:
            storages[key] = TransientStorage(generator: entity)
        case .weak:
            storages[key] = WeakStorage(generator: entity)
        }
    }
}

extension Container: Resolver {
    public func optionalResolve<T>(_ type: T.Type, with arguments: Arguments) -> T? {
        return storages[key(type)]?.resolve(with: self, arguments: arguments) as? T
    }
}

extension Container /* Storyboardable */ {
    func makeStoryboardable() {
        assert(NSObject.container.isNil, "storyboard handler was registered twice")
        NSObject.container = .init(value: self)
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
