import Foundation
import SwiftGD

enum GradientError:Error {
    case Empty
    case WrongElementPosition
}

public class Gradient {

    let colors:[Color]
    let count = 255
    
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
        
        
        guard let elemnt = elements.first else {
            throw GradientError.Empty
        }
        
        var colorA:Color = elemnt.0
        var colorNext:Color?
        
        
        var positionA:Int = Int(elemnt.1 * Float(count))
        var positionNext:Int?
    
        var elementIndex = 1
        
        for position in 0...count {
            
            if positionA >= position {
                colors.append(colorA)
                continue
            }
            
            
            if colorNext == nil {
                if elementIndex < elements.count {
                    let element = elements[elementIndex]
                    elementIndex += 1
                    colorNext = element.0
                    positionNext = Int(element.1 * Float(count))
                }
            }

            guard let colorB = colorNext, let positionB = positionNext else {
                throw GradientError.WrongElementPosition
            }
            
            if position >= positionB {
                colors.append(colorB)
                continue
            }
            
            let gradientLength = positionB - positionA
            let d = Double(position - positionA) / Double(gradientLength)
            let color = colorB - (colorB - colorA) * d
            colors.append(color)
        }
        
        self.colors = colors
        
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
