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
    
    return lhs.G.x == rhs.G.x && lhs.G.y == rhs.G.y && lhs.a == rhs.a &&  lhs.b == rhs.b &&  lhs.n == rhs.n &&  lhs.h == rhs.h
}

@prefix public func - (rhs: ECPoint) -> ECPoint {
    if rhs.isInfinity {
        return rhs
    }
    
    assert(rhs.x, "x set")
    let x₁ = rhs.x!
    
    assert(rhs.y, "y set")
    let y₁ = rhs.y!
    
    let y₃ = -y₁
    
    return ECPoint(x: x₁, y: y₃, curve: rhs.curve)
    
}

public func + (lhs: ECPoint, rhs: ECPoint) -> ECPoint {
    assert(lhs.curve == rhs.curve, "Can't add points on different curves")
    
    if lhs.isInfinity {
        return rhs
    }
    
    if rhs.isInfinity {
        return lhs
    }
    
    assert(lhs.x, "lhs x set")
    let x₁ = lhs.x!
    
    assert(lhs.y, "lhs y set")
    let y₁ = lhs.y!
    
    assert(rhs.x, "rhs x set")
    let x₂ = rhs.x!
    
    assert(rhs.y, "rhs y set")
    let y₂ = rhs.y!
    
    
    if lhs == rhs { // P == Q
        return 2 * lhs
    }
    
    if lhs.x! == rhs.x! && lhs.y! + rhs.y! == lhs.curve.field.int(0) { // P(x,y) == Q(x, -y)
        return lhs.curve.infinity
    }
    
    let common = (y₂ - y₁) / (x₂ - x₁)
    let x₃ = common ^^ 2 - x₁ - x₂
    let y₃ = common * (x₁ - x₃) - y₁
    
    return ECPoint(x: x₃, y: y₃, curve: lhs.curve)

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

        assert(x, "lhs x set")
        let x₁ = x!
        
        assert(y, "lhs y set")
        let y₁ = y!

            
        let common = (3 * x₁ ^^ 2 + a) / (2 * y₁)
        let x₃ = common ^^ 2 - 2 * x₁
        let y₃ = common * (x₁ - x₃) - y₁
        
        return curve[x₃, y₃]
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
    
    for var i=0; i < lhsBitLength; i++  {
        if UInt256.singleBitAt(255 - i) & lhs != 0 {
            tally += increment
        }
        increment *= 2
    }
    
    
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