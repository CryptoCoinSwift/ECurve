//
//  ECPointTests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//
//  Example domain from: https://github.com/cryptocoinjs/ecurve/blob/master/test/curve.js

import XCTest
import CryptoCoin

class ECPointTests: XCTestCase {
    
    var field = FiniteField.PrimeField(p: 11)
    
    var curve = ECurve(field: FiniteField.PrimeField(p: 11), g: nil, gX: UInt256(8), gY: UInt256(6), a: UInt256(1), b: UInt256(0), n: UInt256(12), h: nil)
    
    // y^2 = x^3 + x (in terms of finite field arithmatic)
    // E.g. for the base point: (x = 8, y=6)
    // y^2 = y * y = 6 * 6 = 36 % 11 = 3
    // x^3 = x * (x * x) = 8 * (8 * 8) = 8 * (64 % 11) = 8 * 9 = 6
    // 3 == (6 + 8) % 11 = 3
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitWithG() {
        // Initialize the point G of a secp256k1 curve on itself.
        curve = ECurve(domain: .Secp256k1)
        
        let g = ECPoint(x: EllipticCurveDomain.Secp256k1.gX, y: EllipticCurveDomain.Secp256k1.gY, curve: curve)
        
        XCTAssertEqual(g.x!.toHexString, EllipticCurveDomain.Secp256k1.gX.toHexString, "Gx hex");
        XCTAssertTrue(g.x! == EllipticCurveDomain.Secp256k1.gX, "Gx equality");
    }
    
    
//    func testInitWithCompressedPoint() {
//        let curve = ECurve(domain: .Secp256k1)
//        let x = UInt256(hexStringValue: "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798")
//        let y = UInt256(hexStringValue: "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8")
//        
//        let a:ECPoint = ECPoint(x: x, y: y, curve: curve)
//
//        let b:ECPoint = ECPoint(compressedPointHexString: "0279BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", curve: curve)
//        
//        XCTAssertTrue(a == b, "Decompress point");
//    }
    
    func testInitWithInfinity() {
        let a = curve.infinity
        
        XCTAssertTrue(a.isInfinity, "and beyond!")
    }
    
}
