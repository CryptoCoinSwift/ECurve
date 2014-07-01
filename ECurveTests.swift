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
    
    func testInitWithDomain() {
        let curve = ECurve(domain: .Secp256k1)
        XCTAssertEqual(curve.domain!, .Secp256k1);

    }
    
    func testInitWithParams() {
        let a = ECurve(domain: .Secp256k1)
        
        let domain: EllipticCurveDomain = .Secp256k1
        
        let b = ECurve(field: domain.field, gX: domain.gX, gY: domain.gY, a: domain.a, b: domain.b, n: domain.n, h: domain.h)

        XCTAssertTrue(a == b);
    }
    

    func testBasePoint() {
        let curve = ECurve(domain: .Secp256k1)
        
        let a = ECPoint(x: EllipticCurveDomain.Secp256k1.gX, y: EllipticCurveDomain.Secp256k1.gY, curve: curve)
        
        let b = curve.G
        
        XCTAssertTrue(a == b, "Basepoint");

    }
 }
