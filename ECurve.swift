//
//  ECurve.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

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
    
    return lhs.G == rhs.G &&  lhs.a == rhs.a &&  lhs.b == rhs.b &&  lhs.n == rhs.n &&  lhs.h == rhs.h
}

