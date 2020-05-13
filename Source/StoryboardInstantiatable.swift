import Foundation
import UIKit
import ObjectiveC

extension NSObject {
    private enum AssociatedKeys {
        static var initialization = "NInject.isInitializedFromDI"
        static var container = "NInject.container"
        static var dipTag = "NInject.dipTag"
    }

    @objc private var isInitializedFromDI: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.initialization) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.initialization, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc internal static var container: ContainerPropertyHolder? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.container) as? ContainerPropertyHolder
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.container, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private(set) internal var dipTag: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dipTag) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dipTag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if isInitializedFromDI {
                return
            }
            isInitializedFromDI = true

            NSObject.container?.value.resolveStoryboardable(self)
        }
    }
}

class ContainerPropertyHolder: NSObject {
    let value: Container

    required init(value: Container) {
        self.value = value
        super.init()
    }
}
