//
//  ECPoint.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// List of methods that should be supported:
// http://cryptocoinjs.com/modules/crypto/ecurve/  (under Point)
// Use Swift style syntax where possible. E.g. not point.add(point), but point + point

import UInt256Mac

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
