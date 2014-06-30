//
//  ECPoint.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// List of methods that should be supported:
// http://cryptocoinjs.com/modules/crypto/ecurve/  (under Point)
// Use Swift style syntax where possible. E.g. not point.add(point), but point + point

struct ECPoint {
    let curve: ECurve
    let x: UInt256?
    let y: UInt256?
    
    init(x: UInt256?, y: UInt256?, curve: ECurve) {
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
}

func == (lhs: ECPoint, rhs: ECPoint) -> Bool {
    return lhs.curve == rhs.curve && lhs.x == rhs.x && lhs.y == rhs.y
}
