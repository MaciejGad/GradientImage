import XCTest
import SwiftGD

@testable import GradientImage

class GradientImageTests: XCTestCase {
    func testOneColorGradient() throws {
        //given
        let color = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        
        //when
        let sut = try Gradient((color, 1))
        
        //then
        XCTAssertEqual(sut.colors[0], color)
        XCTAssertEqual(sut.colors[255], color)
    }
    
    func testOneColorWrongGradient() throws {
        //given
        let color = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        
        //when
        var exeptionOccurs = false
        
        do {
            let _ = try Gradient((color, 0.5))
        } catch GradientError.WrongElementPosition {
            exeptionOccurs = true
        }
        
        //then
        XCTAssertTrue(exeptionOccurs)
    }

    func testTwoColorGradient() throws {
        //given
        let startColor = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        let endColor   = Color(red: 0.0, green: 0, blue: 1.0, alpha: 1)
        
        //when
        let sut = try Gradient((startColor, 0), (endColor, 1))
        
        //then
        XCTAssertEqual(sut.colors[0], startColor)
        let middle = sut.colors[127]
        print("r = \(middle.redComponent), b = \(middle.blueComponent)")
        XCTAssertEqual(sut.colors[127],  Color(red: 0.5, green: 0, blue: 0.5, alpha: 1))
        XCTAssertEqual(sut.colors[255], endColor)
    }

    static var allTests : [(String, (GradientImageTests) -> () throws -> Void)] {
        return [
            ("testOneColorGradient", testOneColorGradient),
        ]
    }
}
