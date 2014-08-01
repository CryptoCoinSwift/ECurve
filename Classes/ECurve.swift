//
//  ECurve.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

import UInt256Mac

public struct ECurve {
    public let domain: EllipticCurveDomain?
    
    public let field: FiniteField
    
    // let G: ECPoint // ECPoint refers to an ECurve, so this would create a cycle
    public let gX: FFInt
    public let gY: FFInt
    
    public let a: UInt256
    public let b: UInt256
    
    public let n: UInt256
    public let h: UInt256?
    
    public init(domain: EllipticCurveDomain) {
        self.domain = domain
        
        self.field = domain.field
        self.a = domain.a
        self.b = domain.b
        self.n = domain.n
        self.h = domain.h
        
    self.gX = domain.gX
    self.gY = domain.gY


        //        self.G = ECPoint(x: domain.gX, y: domain.gY, curve: nil)

    }
    
    public init(field: FiniteField, gX: FFInt, gY: FFInt, a: UInt256, b: UInt256, n: UInt256, h: UInt256?) {
        self.field = field
        
        self.a = a
        self.b = b
        self.n = n
        self.h = h

        self.gX = gX
        self.gY = gY
        

    }
    
    public var G: ECPoint {
        return ECPoint(x: gX, y:gY, curve: self)
    }
    
    public var infinity: ECPoint {
        return ECPoint.infinity(self)
    }
    
    public subscript(x: UInt256, y: UInt256) -> ECPoint {
        return ECPoint(x: FFInt(x, self.field), y: FFInt(y, self.field), curve: self)
    }
    
    public subscript(x: FFInt, y: FFInt) -> ECPoint {
        return ECPoint(x: x, y: y, curve: self)
    }
    
    // The compiler won't let me...
    // let ∞ = infinity
}

public func == (lhs: ECurve, rhs: ECurve) -> Bool {
    if(lhs.domain == rhs.domain) {
        return true
    }
    
    switch (lhs.G.coordinate, rhs.G.coordinate) {
    case let (.Affine(lhsX,lhsY), .Affine(rhsX,rhsY) ):
        return lhsX == rhsX && rhsY == rhsY  && lhs.a == rhs.a &&  lhs.b == rhs.b &&  lhs.n == rhs.n &&  lhs.h == rhs.h

    default:
        assert(false, "Not implemented")
        return false
    }

    
}

@prefix public func - (rhs: ECPoint) -> ECPoint {
    switch rhs.coordinate {
    case let .Affine(x,y):
        if rhs.isInfinity {
            return rhs
        }
        
        assert(x, "x set")
        let x₁ = x!
        
        assert(y, "y set")
        let y₁ = y!
        
        let y₃ = -y₁
        
        return ECPoint(x: x₁, y: y₃, curve: rhs.curve)

    case .Jacobian:
        assert(false, "Not implemented")
        return rhs
    }

    
    
}

public func + (lhs: ECPoint, rhs: ECPoint) -> ECPoint {
    assert(lhs.curve == rhs.curve, "Can't add points on different curves")
    
    switch (lhs.coordinate, rhs.coordinate) {
    case let (.Affine(lhsX,lhsY), .Affine(rhsX,rhsY) ):
    
        if lhs.isInfinity {
            return rhs
        }
        
        if rhs.isInfinity {
            return lhs
        }
        
        assert(lhsX, "lhs x set")
        let x₁ = lhsX!
        
        assert(lhsY, "lhs y set")
        let y₁ = lhsY!
        
        assert(rhsX, "rhs x set")
        let x₂ = rhsX!
        
        assert(rhsY, "rhs y set")
        let y₂ = rhsY!
        
        if lhs == rhs { // P == Q
            return 2 * lhs
        }
        
        if x₁ == x₂ && y₁ + y₂ == lhs.curve.field.int(0) { // P(x,y) == Q(x, -y)
            return lhs.curve.infinity
        }
        
        let common = (y₂ - y₁) / (x₂ - x₁)
        let x₃ = common ^^ 2 - x₁ - x₂
        let y₃ = common * (x₁ - x₃) - y₁
        
        return ECPoint(x: x₃, y: y₃, curve: lhs.curve)

    case let (.Jacobian(X₁, Y₁, Z₁),.Jacobian(X₂, Y₂,Z₂)):
        // See 3.14 on page 89
        
        assert(Z₁ != lhs.curve.field.int(0), "Z₁ should not be 0")
        assert(Z₂ == lhs.curve.field.int(1), "Z₂ must be 1")
        assert(!(X₁ == X₂ && Y₁ == Y₂ && Z₁ == Z₂) , "Can't deal with P == Q")
        assert(!(X₁ == X₂ && Y₁ == -Y₂ && Z₁ == Z₂), "Can't deal with P == -Q")

    
        let A = Z₁ * Z₁
        let B = Z₁ * A
        let C = X₂ * A
        let D = Y₂ * B
        let E = C - X₁
        let F = D - Y₁
        let G = E * E
        let H = G * E
        let I = X₁ * G
        
        let X₃ = F * F - H - 2 * I
        let Y₃ = F * (I - X₃) - Y₁ * H
        let Z₃ = Z₁ * E
        
        return ECPoint(coordinate: .Jacobian(X: X₃, Y: Y₃,Z: Z₃), curve: lhs.curve)
    default:
        assert(false, "Combining different coordinate systems not implemented'")
        return rhs
    }
}

public func += (inout lhs: ECPoint, rhs: ECPoint) -> () {
    lhs = lhs + rhs
}


public func *= (inout lhs: ECPoint, rhs: UInt256) -> () {
    lhs = rhs * lhs
}

extension ECPoint {
    public var double: ECPoint {
        let a = curve.field.int(self.curve.a)
            
        switch coordinate {
        case let .Affine(x,y):

            assert(x, "lhs x set")
            let x₁ = x!
            
            assert(y, "lhs y set")
            let y₁ = y!

                
            let common = (3 * x₁ ^^ 2 + a) / (2 * y₁)
            let x₃ = common ^^ 2 - 2 * x₁
            let y₃ = common * (x₁ - x₃) - y₁
            
            return curve[x₃, y₃]
        case let .Jacobian(X₁,Y₁,Z₁):
            // Check that P != -P
            // Negative of (X : Y : Z) is (X : -Y : Z)
            assert(Y₁ != -Y₁, "Can't deal with P == -P")
            
            let X₁² = X₁ * X₁
            let X₁⁴ = X₁² * X₁²
            
            let Y₁² = Y₁ * Y₁
            let Y₁⁴ = Y₁² * Y₁²
            
            var D: FFInt
            if(a == curve.field.int(0)) {
                D = 3 * X₁²
            } else {
                let Z₁² = Z₁ * Z₁
                let Z₁⁴ = Z₁² * Z₁²
                D = 3 * X₁² + a * Z₁⁴
            }
            

            let X₃ = D * D - 8 * X₁ * Y₁²
            let Y₃ = D * (4 * X₁ * Y₁² - X₃) - 8 * Y₁⁴
            let Z₃ = 2 * Y₁ * Z₁
            
            return ECPoint(coordinate: .Jacobian(X: X₃, Y: Y₃,Z: Z₃), curve: curve)
        }
    }
}

public func * (lhs: UInt256, rhs: ECPoint) -> ECPoint {
    
    if rhs.isInfinity {
        return rhs
    }
    
    if lhs == 0 {
        return rhs.curve.infinity
    }
    
    if lhs == 2 {
        return rhs.double
        
    }
    
    let P = rhs
    
    var tally = P.curve.infinity
    var increment = P
    
    let lhsBitLength = lhs.highestBit
    
//    increment.convertToJacobian();
//    tally.convertToJacobian();
    
    for var i=0; i < lhsBitLength; i++  {
        if UInt256.singleBitAt(255 - i) & lhs != 0 {
            tally += increment
        }
        increment *= 2 // TODO: use a lookup table when available
    }
    
//    tally.convertToAffine();
    
    return tally
}

// Convenience method. Mostly so that doubling a point doesn't require lhs to
// be cast in and out of UInt256.
public func * (lhs: Int, rhs: ECPoint) -> ECPoint {
    
    let isInfinity = 1
    let isInfenity = 2
    
    
    
    let lhsInt: UInt256 = UInt256(UInt32(lhs))

    if rhs.isInfinity {
        return rhs
    }
    
    if lhs == 0 {
        return rhs.curve.infinity
    }
    
    if lhs == 2 {
        return rhs.double
    }
    
    return lhsInt * rhs
}