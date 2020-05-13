import Foundation
import UIKit
import Quick
import Nimble
import Spry
import Spry_Nimble
import Swinject
import SwinjectStoryboard

@testable import NSwinject
@testable import NSwinjectTestHelpers

class NViewControllerFactorySpec: QuickSpec {
    override func spec() {
        describe("NViewControllerFactory") {
            var subject: NViewControllerFactory!

            beforeEach {
                let container = SwinjectStoryboard.defaultContainer
                container.storyboardInitCompleted(TestViewController.self) { _, _ in }
                container.storyboardInitCompleted(UIViewController.self) { _, _ in }

                subject = NViewControllerFactoryImpl(container: container)
            }

            describe("creating view controller") {
                var viewController: TestViewController?

                beforeEach {
                    viewController = subject.instantiate()
                }

                it("should create corresponded view controller") {
                    expect(viewController).toNot(beNil())
                }
            }

            describe("creating navigation controller") {
                var navigationController: (UINavigationController, TestViewController)?

                beforeEach {
                    navigationController = subject.createNavigationController()
                }

                it("should create corresponded navigation controller") {
                    expect(navigationController).toNot(beNil())
                    expect(navigationController?.0.viewControllers.first).to(beAnInstanceOf(TestViewController.self))
                    expect(navigationController?.1).to(beAnInstanceOf(TestViewController.self))
                }
            }
        }
    }
}
