//
//  ECPoint.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// List of methods that should be supported:
// http://cryptocoinjs.com/modules/crypto/ecurve/  (under Point)
// Use Swift style syntax where possible. E.g. not point.add(point), but point + point

struct ECPoint : Printable {
    let curve: ECurve
    let x: FFInt?
    let y: FFInt?
    
    init(x: FFInt?, y: FFInt?, curve: ECurve) {
        self.curve = curve
        
        self.x = x
        self.y = y
    }
    
    //    http://nmav.gnutls.org/2012/01/do-we-need-elliptic-curve-point.html
    //    https://bitcointalk.org/index.php?topic=237260.0
    //
    //    init(compressedPointHexString: String, curve: ECurve) {
    //        self.curve = curve
    //
    //        self.x = UInt256(decimalStringValue: "0")
    //        self.y = UInt256(decimalStringValue: "0")
    //    }
    
    static func infinity (curve: ECurve) ->  ECPoint {
        return ECPoint(x: nil, y: nil, curve: curve)
    }
    
    var isInfinity: Bool {
        return x == nil && y == nil
    }
    
    var description: String {
        if self.isInfinity {
          return "Infinity"
        } else {
          return "(\(self.x!.value.description), \( self.y!.value.description ))"
        }
    }
}

func == (lhs: ECPoint, rhs: ECPoint) -> Bool {
    return lhs.curve == rhs.curve && lhs.x == rhs.x && lhs.y == rhs.y
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
        let two = rhs.curve.field.int(2)
        let three = rhs.curve.field.int(3)
        let a = rhs.curve.field.int(rhs.curve.a)
        let common = (three * x₁ * x₁ + a) / (two * y₁)
        
        let x₃ = common * common - rhs.curve.field.int(2) * x₁
        
        let y₃ = common * (x₁ - x₃) - y₁
        
        return ECPoint(x: x₃, y: y₃, curve: rhs.curve)

    }
    
    let P = rhs
    
    var tally = P.curve.infinity
    var increment = P
    
    for var i=0; i < lhs.highestBit; i++  {
        if UInt256.singleBitAt(255 - i) & lhs != 0 {
            tally += increment
        }
                
        increment *= 2
    }
    
    return tally
}

