import XCTest
@testable import GradientImage

class GradientImageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(GradientImage().text, "Hello, World!")
    }


    static var allTests : [(String, (GradientImageTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
