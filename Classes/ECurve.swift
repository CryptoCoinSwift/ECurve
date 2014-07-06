//
//  ECurve.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

import UInt256Mac

struct ECurve {
    let domain: EllipticCurveDomain?
    
    let field: FiniteField
    
    // let G: ECPoint // ECPoint refers to an ECurve, so this would create a cycle
    let gX: FFInt
    let gY: FFInt
    
    let a: UInt256
    let b: UInt256
    
    let n: UInt256
    let h: UInt256?
    
    init(domain: EllipticCurveDomain) {
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
    
    init(field: FiniteField, gX: FFInt, gY: FFInt, a: UInt256, b: UInt256, n: UInt256, h: UInt256?) {
        self.field = field
        
        self.a = a
        self.b = b
        self.n = n
        self.h = h

        self.gX = gX
        self.gY = gY
        

    }
    
    var G: ECPoint {
        return ECPoint(x: gX, y:gY, curve: self)
    }
    
    var infinity: ECPoint {
        return ECPoint.infinity(self)
    }
    
    subscript(x: UInt256, y: UInt256) -> ECPoint {
        return ECPoint(x: FFInt(value: x, field: self.field), y: FFInt(value: y, field: self.field), curve: self)
    }
    
    // The compiler won't let me...
    // let ∞ = infinity
}

func == (lhs: ECurve, rhs: ECurve) -> Bool {
    if(lhs.domain == rhs.domain) {
        return true
    }
    
    return lhs.G.x == rhs.G.x && lhs.G.y == rhs.G.y && lhs.a == rhs.a &&  lhs.b == rhs.b &&  lhs.n == rhs.n &&  lhs.h == rhs.h
}

@prefix func - (rhs: ECPoint) -> ECPoint {
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

func + (lhs: ECPoint, rhs: ECPoint) -> ECPoint {
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
    
    let x₃ = common * common - x₁ - x₂
    
    let y₃ = common * (x₁ - x₃) - y₁
    
    return ECPoint(x: x₃, y: y₃, curve: lhs.curve)
    
}

func += (inout lhs: ECPoint, rhs: ECPoint) -> () {
    lhs = lhs + rhs
}


func *= (inout lhs: ECPoint, rhs: UInt256) -> () {
    lhs = rhs * lhs
}

func * (lhs: Int, rhs: ECPoint) -> ECPoint {
    return UInt256(lhs) * rhs
}

func * (lhs: UInt256, rhs: ECPoint) -> ECPoint {
    
    if rhs.isInfinity {
        return rhs
    }
    
    if lhs == 0 {
        return rhs.curve.infinity
    }
    
    assert(rhs.x, "lhs x set")
    let x₁ = rhs.x!
    
    assert(rhs.y, "lhs y set")
    let y₁ = rhs.y!
    
    if lhs == 2 {
        let a = rhs.curve.field.int(rhs.curve.a)
        
        let common = (3 * x₁ * x₁ + a) / (2 * y₁)
        
        let x₃ = common * common - 2 * x₁
        
        let y₃ = common * (x₁ - x₃) - y₁
        
        return ECPoint(x: x₃, y: y₃, curve: rhs.curve)
        
    }
    
    let P = rhs
    
    var tally = P.curve.infinity
    var increment = P
    
    let lhsBitLength = lhs.highestBit
    
    for var i=0; i < lhsBitLength; i++  {
        if lhsBitLength > 200 && i % 5 == 0 {
            println("i = \( i  * 100 / 256 )% ")
        }
        if UInt256.singleBitAt(255 - i) & lhs != 0 {
            tally += increment
        }
        increment *= 2
    }
    
    
    return tally
}
