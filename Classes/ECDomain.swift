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
//           p: 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f,
//           a: 0
//           b: 7)
//           ....)

import UInt256Mac

public enum EllipticCurveDomain {
    case Secp256k1

    public var field: FiniteField {
        switch self {
        case .Secp256k1:
            // 2^256 - 2^32 - 2^9 - 2^8 - 2^7 - 2^6 - 2^4 - 1
            return FiniteField.PrimeField(p: UInt256(0xffffffff, 0xffffffff, 0xffffffff,0xffffffff, 0xffffffff,0xffffffff, 0xfffffffe,0xfffffc2f))
        }
    }
    
    //  The curve E: y^2 + x^3 + ax +b over Fp.
    public var a: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256.allZeros
        }
    }
    
    public var b: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256(7)
        }
    }
    
    // The base point G in compressed form is:
    public var g: String {
        switch self {
        case .Secp256k1:
            return "0279BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"
        }
    }
    
    // Base point expressed in X and Y coordinates (uncompressed form with 04 left out of the beginning)
    public var gX: FFInt {
        switch self {
        case .Secp256k1:
            return field.int(UInt256(0x79be667e, 0xf9dcbbac, 0x55a06295, 0xce870b07, 0x029bfcdb, 0x2dce28d9, 0x59f2815b, 0x16f81798))
            }
        }
    
    public var gY: FFInt {
        switch self {
        case .Secp256k1:
            return field.int(UInt256(0x483ada77,0x26a3c465,0x5da4fbfc,0x0e1108a8,0xfd17b448,0xa6855419, 0x9c47d08f,0xfb10d4b8))
            }
        }
    
    // The order n of G
    public var n: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256(0xffffffff,0xffffffff,0xffffffff,0xfffffffe,0xbaaedce6,0xaf48a03b,0xbfd25e8c,0xd0364141)
            }
        }
    
    // The cofactor:
    public var h: UInt256 {
        switch self {
        case .Secp256k1:
            return UInt256(1)
        }
    }
}
