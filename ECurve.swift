//
//  ECurve.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

//import CryptoCoin

struct ECurve {
    let domain: EllipticCurveDomain?
    
    let field: FiniteField
    
    let g: String? // Compressed
    let gX: UInt256
    let gY: UInt256
    
    let a: UInt256
    let b: UInt256
    
    let n: UInt256
    let h: UInt256
    
    init(domain: EllipticCurveDomain) {
        self.domain = domain
        
        self.field = domain.field
        self.gX = domain.gX
        self.gY = domain.gY
        self.g = domain.g
        self.a = domain.a
        self.b = domain.b
        self.n = domain.n
        self.h = domain.h
    }
    
    init(field: FiniteField, g: String?, gX: UInt256, gY: UInt256, a: UInt256, b: UInt256, n: UInt256, h: UInt256) {
        self.field = field
        
        self.gX = gX
        self.gY = gY
        self.g = g
        self.a = a
        self.b = b
        self.n = n
        self.h = h
    }
    
    var basePoint: ECPoint {
        return ECPoint(x: gX, y: gY, curve: self)
    }
}

func == (lhs: ECurve, rhs: ECurve) -> Bool {
    if(lhs.domain == rhs.domain) {
        return true
    }
    
    return lhs.gX == rhs.gX && lhs.gY == rhs.gY &&  lhs.a == rhs.a &&  lhs.b == rhs.b &&  lhs.n == rhs.n &&  lhs.h == rhs.h
}

