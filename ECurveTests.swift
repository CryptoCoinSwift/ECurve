//
//  ECurveTests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//

import XCTest
import CryptoCoin

class ECurveTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testBasePoint() {
        let curve = ECurve(domain: .Secp256k1)
        
        let a = ECPoint(x: EllipticCurveDomain.Secp256k1.gX, y: EllipticCurveDomain.Secp256k1.gY, curve: curve)
        
        let b = curve.basePoint
        
        XCTAssertTrue(a == b, "Basepoint");

    }
 }
