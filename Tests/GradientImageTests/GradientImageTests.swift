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
        let sut = try Gradient((color, 0.5))
        
        //then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.colors[0], color)
        XCTAssertEqual(sut.colors[255], color)
    }

    func testTwoColorGradient() throws {
        //given
        let startColor = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        let endColor   = Color(red: 0.0, green: 0, blue: 1.0, alpha: 1)
        
        //when
        let sut = try Gradient((startColor, 0), (endColor, 1))
        
        //then
        XCTAssertEqual(sut.colors[0], startColor)
        XCTAssertEqual(sut.colors[127],  Color(red: 0.5, green: 0, blue: 0.5, alpha: 1))
        XCTAssertEqual(sut.colors[255], endColor)
    }
    
    func testThreeColorGradient() throws {
        //given
        let startColor  = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        let middleColor = Color(red: 0.0, green:1.0, blue: 0, alpha: 1)
        let endColor    = Color(red: 0.0, green: 0, blue: 1.0, alpha: 1)
        
        //when
        let sut = try Gradient((startColor, 0), (middleColor, 0.5), (endColor, 1))
        
        //then
        XCTAssertEqual(sut.colors[0], startColor)
        XCTAssertEqual(sut.colors[63],  Color(red:0.504, green:0.497 , blue: 0.0, alpha: 1))
        XCTAssertEqual(sut.colors[127],  middleColor)
        XCTAssertEqual(sut.colors[255], endColor)
    }
    
    func testThreeWithMarginColorGradient() throws {
        //given
        let startColor  = Color(red: 1.0, green: 0, blue: 0, alpha: 1)
        let middleColor = Color(red: 0.0, green:1.0, blue: 0, alpha: 1)
        let endColor    = Color(red: 0.0, green: 0, blue: 1.0, alpha: 1)
        
        //when
        let sut = try Gradient((startColor, 0.1), (middleColor, 0.5), (endColor, 0.9))
        
        //then
        XCTAssertEqual(sut.colors[0], startColor)
        XCTAssertEqual(sut.colors[127],  middleColor)
        XCTAssertEqual(sut.colors[255], endColor)
    }
    
    func testApplayGradient() throws {
        //given
        let startColor  = Color(red: 200.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1)
        let middleColor = Color(red: 0.0, green:174.0/255, blue: 172.0/255, alpha: 1)
        let endColor    = Color(red: 100.0/255, green: 51.0/255, blue: 99.0/255, alpha: 1)
        
        
        let imageUrl = try generateBWGradientImage()
        let image = Image(url: imageUrl)!
        let gradient = try Gradient((startColor, 0.0), (middleColor, 0.5), (endColor, 0.91))
        
        //when
        image.applay(gradient:gradient)
        
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent( UUID().uuidString + ".jpg")
        
        image.write(to: url)
        print("image writen to: \(url.path)")
        
        //then
        print("check if is correct")
    }
    
    func testCreateGradientImage() throws {
        let startColor  = Color(red: 200.0/255, green: 210.0/255, blue: 210.0/255, alpha: 1)
        let middleColor = Color(red: 0.0, green:174.0/255, blue: 172.0/255, alpha: 1)
        let endColor    = Color(red: 100.0/255, green: 51.0/255, blue: 99.0/255, alpha: 1)
        
        let gradient = try Gradient((startColor, 0.0), (middleColor, 0.5), (endColor, 0.91))
        
         //when
        
        guard let image = gradient.image() else {
            XCTFail("can't generate gradient image")
            return
        }
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent( UUID().uuidString + ".jpg")
        
        image.write(to: url)
        print("image writen to: \(url.path)")
        
        //then
        print("check if is correct")

    }
    
    func generateBWGradientImage() throws -> URL  {
        let startColor  = Color(red: 1, green: 1, blue: 1, alpha: 1)
        let endColor    = Color(red: 0, green: 0, blue: 0, alpha: 1)
        
        let gradient = try Gradient((startColor, 0.0), (endColor, 1))
        
        guard let image = gradient.image() else {
            throw TestError.imageGenerate
        }
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent( "b_w_\(UUID().uuidString).jpg")
        
        if !image.write(to: url) {
            throw TestError.imageGenerate
        }
        print("image writen to: \(url.path)")
        
        return url
    }
    
    static var allTests : [(String, (GradientImageTests) -> () throws -> Void)] {
        return [
            ("testOneColorGradient", testOneColorGradient),
            ("testOneColorWrongGradient", testOneColorWrongGradient),
            ("testTwoColorGradient", testTwoColorGradient),
            ("testThreeColorGradient", testThreeColorGradient),
            ("testThreeWithMarginColorGradient", testThreeWithMarginColorGradient),
            ("testApplayGradient", testApplayGradient),
            ("testCreateGradientImage", testCreateGradientImage)
        ]
    }
}

enum TestError: Error {
    case imageGenerate
}


