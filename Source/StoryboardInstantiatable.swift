import Foundation
import UIKit
import ObjectiveC

extension NSObject {
    private enum AssociatedKeys {
        static var initialization = "NInject.isInitializedFromDI"
        static var container = "NInject.container"
        static var dipTag = "NInject.dipTag"
    }

    @objc internal var isInitializedFromDI: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.initialization) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.initialization, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private static var containerHolder: ContainerPropertyHolder? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.container) as? ContainerPropertyHolder
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.container, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal static var container: Container? {
        get {
            return containerHolder?.value
        }
        set {
            containerHolder = newValue.map({ ContainerPropertyHolder(value: $0) })
        }
    }

    @objc private(set) internal var dipTag: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dipTag) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dipTag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            resolveDependencies()
        }
    }

    public func resolveDependenciesManually() {
        resolveDependencies()
    }

    private func resolveDependencies() {
        if isInitializedFromDI {
            return
        }
        isInitializedFromDI = true

        NSObject.container?.resolveStoryboardable(self)
    }
}

class ContainerPropertyHolder: NSObject {
    weak var value: Container?

    required init(value: Container) {
        self.value = value
        super.init()
    }
}
