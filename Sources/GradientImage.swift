import Foundation
import SwiftGD

enum GradientError:Error {
    case Empty
    case WrongElementPosition
}

public class Gradient {

    static let count = 255
    
    struct Elemnt {
        let color:Color
        let position:Int
        
        init(color: Color, position: Float) {
            self.color = color
            self.position = Int(position * Float(count))
        }
    }
    
    let colors:[Color]

    
    init( _ elements:(Color, Float)...) throws {
        
        /*
 
         when count == 4
         color:    A, A1, A2, A3, B
         position: 0, 1,  2,  3,  4
 
         p(A) = position of A (i.e 0)
         
         gradientLength = p(B) - p(A)
         d(A1) = (p(A1) - p(A)) / gradientLength
         
         A1 = B - (B - A) * d(A1)
         A(n) = B - (B - A) * d(A(n))
         
        */
        
        var colors:[Color] = []
        
        let pairs = elements.map{Elemnt(color:$0.0, position:$0.1)}.pairs()
        
        guard var pair = pairs.first else {
            throw GradientError.Empty
        }
        
        var colorA:Color = pair.0.color
        var colorB:Color = pair.1.color
        
        
        var positionA:Int = pair.0.position
        var positionB:Int = pair.1.position
    
        var elementIndex = 1
        var lastElement = false
        for position in 0...Gradient.count {
            
            if positionA >= position {
                colors.append(colorA)
                continue
            }
            
            if positionB < position && !lastElement {
                if elementIndex < pairs.count {
                    pair = pairs[elementIndex]
                    elementIndex += 1

                    colorA = pair.0.color
                    colorB = pair.1.color

                    positionA = pair.0.position
                    positionB = pair.1.position
                } else {
                    lastElement = true
                }
            }

                    
            if lastElement {
                colors.append(colorB)
                continue
            }
            
            let gradientLength = positionB - positionA
            let d = Double(position - positionA) / Double(gradientLength)
            let color = colorA * (1.0 - d ) + colorB * d
            colors.append(color)
        }
        
        self.colors = colors
        
    }
}

extension Image {
    func applay(gradient:Gradient) {
        desaturate()
        let s = size
        for x in 0..<s.width {
            for y in 0..<s.height  {
                let point = Point(x: x, y: y)
                let color = get(pixel: point)
                var positon = Int((1 - color.redComponent) * Double(Gradient.count))
                if positon > Gradient.count {
                    positon = Gradient.count
                }
                if positon < 0 {
                    positon = 0
                }
                let newColor = gradient.colors[positon]
                set(pixel: point, to: newColor)
            }
        }
    }
}

extension Gradient {
    func image() -> Image? {
        guard let image = Image(width: 256, height: 50) else {
            return nil
        }
        
        for x in 0...Gradient.count {
            let color = colors[x]
            for y in 0..<50 {
                let point = Point(x: x, y: y)
                image.set(pixel: point, to: color)
            }
        }
        return image
    }
}

extension Color:Equatable {
    public static func == (lhs: Color, rhs: Color) -> Bool {
        
        let epsilon = Double(0.5 / 255)
        
        guard fabs(lhs.alphaComponent - rhs.alphaComponent) < epsilon  else {
            return false
        }
        
        guard fabs(lhs.redComponent - rhs.redComponent) < epsilon else {
            return false
        }
        
        guard fabs(lhs.greenComponent - rhs.greenComponent) < epsilon else {
            return false
        }
        
        guard fabs(lhs.blueComponent - rhs.blueComponent) < epsilon else {
            return false
        }
        
        return true
    }
    
    public static func - (lhs: Color, rhs: Color) -> Color {
        let alpha = fabs(lhs.alphaComponent - rhs.alphaComponent)
        let red = fabs(lhs.redComponent - rhs.redComponent)
        let green = fabs(lhs.greenComponent - rhs.greenComponent)
        let blue = fabs(lhs.blueComponent  - rhs.blueComponent)
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func + (lhs: Color, rhs: Color) -> Color {
        let alpha = fabs(lhs.alphaComponent + rhs.alphaComponent)
        let red = fabs(lhs.redComponent + rhs.redComponent)
        let green = fabs(lhs.greenComponent + rhs.greenComponent)
        let blue = fabs(lhs.blueComponent  + rhs.blueComponent)
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    public static func * (lhs: Color, rhs: Double) -> Color {
        let alpha = oneOrLess(fabs(lhs.alphaComponent * rhs))
        let red = oneOrLess(fabs(lhs.redComponent * rhs))
        let green = oneOrLess(fabs(lhs.greenComponent * rhs))
        let blue = oneOrLess(fabs(lhs.blueComponent * rhs))
        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func oneOrLess(_ value:Double) -> Double {
        if value > 1.0 {
            return 1.0
        }
        if value < 0.0 {
            return 0.0
        }
        return value
    }
}

extension Array {

    public func pairs() -> [(Element, Element)]{
        
        guard count != 0 else {
            return []
        }
        
        var pairs:[(Element, Element)] = []
        
        var iterator = makeIterator()
        
        guard var beging = iterator.next() else {
            return []
        }
        
        guard count > 1 else {
            return [(beging, beging)]
        }

        
        while let end = iterator.next() {
            pairs.append((beging, end))
            beging = end
        }
        return pairs
    }
}

extension Color: CustomStringConvertible {
    public var description: String {
        return "(r:\(redComponent), g:\(greenComponent), b:\(blueComponent))"
    }
}

