//
//  ECPoint.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

//import CryptoCoin

struct ECPoint {
    let curve: ECurve
    let x: UInt256
    let y: UInt256
    
    init(x: UInt256, y: UInt256, curve: ECurve) {
        self.curve = curve
        
        // I don't fully undersand or trust Swift arrays
        self.x = UInt256(mostSignificantOf8UInt32First: x.smallerIntegers.copy())
        self.y = UInt256(mostSignificantOf8UInt32First: y.smallerIntegers.copy())
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
}

func == (lhs: ECPoint, rhs: ECPoint) -> Bool {
    return lhs.curve == rhs.curve && lhs.x == rhs.x && lhs.y == rhs.y
}
