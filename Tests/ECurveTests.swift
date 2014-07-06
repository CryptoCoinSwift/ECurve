//
//  ECurveTests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//

import XCTest
import ECurveMac
import UInt256Mac

class ECurveTests: XCTestCase {
    
    var field = FiniteField.PrimeField(p: 11)
    
    var curve = ECurve(field: FiniteField.PrimeField(p: 11), gX: FiniteField.PrimeField(p: 11).int(8), gY: FiniteField.PrimeField(p: 11).int(6), a: UInt256(1), b: UInt256(0), n: UInt256(12), h: nil)
    
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
    
    func testAddInfinity() {
        // See e.g. page 80 in Guide to Elliptic Curve Cryptography, Hankerson e.a.
        // P + ∞ = ∞ + P = P
        let inf = curve.infinity
        let P: ECPoint = curve[5,8]
        
        var sum: ECPoint = inf + P
        var sumDescription: String = sum.description
        
        XCTAssertTrue(sum == P, sumDescription);
        
        //        XCTAssertEqual(sum, P, sumDescription);
        
        sum = P + inf
        sumDescription = sum.description
        
        XCTAssertTrue(sum == P, sumDescription);
        
        //        XCTAssertEqual(sum, P, sumDescription);
        
    }
    
    func negate() {
        let P = curve[5,8]
        let Q = curve[5,3] // Negative: [5, -8] = [5, 3]
        
        let minusP = -P
        
        XCTAssertTrue(minusP == Q, minusP.description);
        
    }
    
    func testAddNegatives() {
        // (x,y) + (x,-y) = ∞
        
        let inf = curve.infinity
        let P = curve[5,8]
        let Q = curve[5,3] // Negative: [5, -8] = [5, 3]
        
        let sum = P + Q
        XCTAssertTrue(sum == inf, sum.description);
        
    }
    
    func testAddNegated() {
        // P + -P = ∞
        let inf = curve.infinity
        
        let P = curve[5,8]
        let sum = P + -P
        
        XCTAssertTrue(sum == inf, sum.description);
    }
    
    func testAdd() {
        let P = curve[5,3]
        let Q = curve[9,10]
        let sum = curve[9,1]
        let result = P + Q
        XCTAssertTrue(sum == result, result.description);
    }
    
    func testAddIsTransitive() {
        let P = curve[5,3]
        let Q = curve[9,10]
        let sum = curve[9,1]
        
        let result = Q + P
        XCTAssertTrue(sum == result, result.description);
        
    }
    
    func testAddZeroZero() {
        let P = curve[5,3]
        let Q = curve[9,10]
        let sum = curve[9,1]
        
        let result = curve[5,3] + curve[0,0]
        XCTAssertTrue(result == curve[9,10], result.description);
    }
    
    func testDouble() {
        var P = curve[5,3]
        let double = curve[5,8]
        var result = 2 * P
        XCTAssertTrue(double == result, result.description);
    }
    
    func testDoubleOther() {
        let  P = curve[9,10]
        let result = 2 * P
        
        XCTAssertTrue(result == curve[5,8], result.description);
    }
    
    //    func testDoubleNegatives() {
    //        // P(x,y) + Q(x,-y) = ∞
    //        // if P = -P then P(x,y) + P(x,-y) = ∞
    //
    //        // This doesn't happen in a p=11 field.
    //
    //        let inf = curve.infinity
    //        let P = curve[.....,....]
    //        let minusP = -P
    //
    //        XCTAssertTrue(P == minusP, "");
    //
    //        let double  = 2 * P
    //
    //        XCTAssertTrue(double == inf, double.description);
    //
    //    }
    
    func testAddSelfIsDouble() {
        let P = curve[5,3]
        let sum = P + P // This should be done through doubling
        let double = 2 * P
        let answer = curve[5,8]
        
        XCTAssertTrue(double == answer, double.description);
        XCTAssertTrue(sum == double, sum.description);
        
    }
    
    func testMultiply() {
        let P = curve[9,10]
        
        var result = 3 * P
        XCTAssertTrue(result == curve[0,0], result.description);
    }
    
    func testMultiplyFourAndFive() {
        let P = curve[9,10]
        
        var result = 4 * P
        XCTAssertTrue(result == curve[5,3], result.description);
        
        result = 5 * P
        XCTAssertTrue(result == curve[9,1], result.description);
    }
    
    func testMultiply16Bit() {
        // Example generated using Sage
        let p = UInt256(65447) // 2^16 - 89
        curve = ECurve(field: FiniteField.PrimeField(p: p), gX: FiniteField.PrimeField(p: p).int(32139), gY: FiniteField.PrimeField(p: p).int(2516), a: UInt256(0), b: UInt256(7), n: UInt256(8181), h: nil)
        
        let d = 910 // Random 16 bit integer < n
        
        let Q = curve[9102, 40965]
        
        let result = d * curve.G
        
        XCTAssertTrue(result == Q, result.description);
    }
    
    func testMultiply32Bit() {
        let p = UInt256(65447) // 2^32 - 107
        // For y=0, ask Wolfram Alpha: solve(1 = x^3 + 7 ) modulo 4294967189
        // Use Sage to calculate and interesting value for G:
        // p = 2^ 32- 107
        // F = FiniteField(p)
        // C = EllipticCurve(F, [ 0, 7 ])
        // seed = C.point((978329252, 0))
        // print seed.order() # Make sure this is big
        // G = 32 * seed
        // print G.order()
        
        curve = ECurve(field: FiniteField.PrimeField(p: p), gX: FiniteField.PrimeField(p: p).int(1244414049), gY: FiniteField.PrimeField(p: p).int(2415436385), a: 0, b: 7, n: 429496719, h: nil)
        
        let d = 358469582 // Random 32 bit integer < n
        
        let Q = curve[1130481541, 1353125538]
        
        let result = d * curve.G
        
        XCTAssertTrue(result == Q, result.description);
    }
    
    // Takes about 12 minutes on a MacBook Pro and currently returns an incorrect result.
    //    func testMultiplyBig() {
    //        curve = ECurve(domain: .Secp256k1)
    //
    //        let a = UInt256(decimalStringValue: "19898843618908353587043383062236220484949425084007183071220218307100305431102")
    //
    //        let b = curve.G
    //
    //        let productX = FFInt(dec: "83225686012142088543596389522774768397204444195709443235253141114409346958144", curve.field)
    //        let productY = FFInt(dec: "23739058578904784236915560265041168694780215705543362357495033621678991351768", curve.field)
    //
    //        let product = ECPoint(x: productX, y: productY, curve: curve)
    //        
    //        let result = a * b
    //        
    //        XCTAssertTrue(result == product, result.description);
    //    }
 }
