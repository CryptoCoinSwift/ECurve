//
//  ECDomain.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//
//  http://www.secg.org/download/aid-386/sec2_final.pdf
//  The elliptic curve domain parameters over Fp associated with a Koblitz curve 
//  (e.g. .Secp256k1are specified bythesextuple T ( p, a, b, G, n, h)
//  The finite field Fp is defined by the values returned by the instance.
//
//  I'm using instance methods on the enum to retrieve the values for each curve,
//  so that you can access them like this:
//
//  let privateKey = UInt256(some big number...)
//  let curve: EllipticCurveDomain = .Secp256k1
//  let publicKey = curve.G * privateKey
//
//  The code below would be more readable if Enum supported a syntax like this:
//
//  enum EllipticCurveDomain (p: UInt256, a: UInt256,  b: UInt256, ...) {
//    case Secp256k1(
//           p: UInt256(hexStringValue: "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f"),
//           a: UInt256.allZeros
//           b: UInt256(hexStringValue: "7")
//           ....)

import UInt256Mac

enum EllipticCurveDomain {
    case Secp256k1

    var field: FiniteField {
        switch self {
        case .Secp256k1:
            // 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1
            return FiniteField.PrimeField(p: UInt256(hexStringValue: "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f"))
        }
    }
    
    //  The curve E: y^2 + x^3 + ax +b over Fp.
    var a: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256.allZeros
        }
    }
    
    var b: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256(hexStringValue: "07")
        }
    }
    
    // The base point G in compressed form is:
    var g: String {
        switch self {
        case .Secp256k1:
            return "0279BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"
        }
    }
    
    // Base point expressed in X and Y coordinates (uncompressed form with 04 left out of the beginning)
    var gX: FFInt {
    switch self {
    case .Secp256k1:
        return field.int(UInt256(hexStringValue: "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"))
        }
    }
    
    var gY: FFInt {
    switch self {
    case .Secp256k1:
        return field.int(UInt256(hexStringValue: "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8"))
        }
    }
    
    // The order n of G
    var n: UInt256 {
    switch self {
    case .Secp256k1:
        return UInt256(hexStringValue: "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141")
        }
    }
    
    // The cofactor:
    var h: UInt256 {
    switch self {
    case .Secp256k1:
        return UInt256(hexStringValue: "01")
        }
    }
}
