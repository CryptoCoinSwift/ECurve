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
        XCTAssertEqual(curve.domain!, EllipticCurveDomain.Secp256k1);

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
        let p = UInt256(decimalStringValue: "4294967189") // 2^32 - 107
        // For y=0, ask Wolfram Alpha: solve(1 = x^3 + 7 ) modulo 4294967189
        // Use Sage to calculate and interesting value for G:
        // p = 2^ 32- 107
        // F = FiniteField(p)
        // C = EllipticCurve(F, [ 0, 7 ])
        // seed = C.point((978329252, 0))
        // print seed.order() # Make sure this is big
        // G = 32 * seed
        // print G.order()
        
        curve = ECurve(field: FiniteField.PrimeField(p: p), gX: FiniteField.PrimeField(p: p).int(1244414049), gY: FiniteField.PrimeField(p: p).int(UInt256(decimalStringValue: "2415436385")), a: 0, b: 7, n: UInt256(decimalStringValue: "429496719"), h: nil)
        
        let d = 358469582 // Random 32 bit integer < n
        
        let Q = curve[1130481541, 1353125538]
        
        let result = d * curve.G
        
        XCTAssertTrue(result == Q, result.description);
    }
    
    func testDouble32Bit() {
        let p = UInt256(decimalStringValue: "4294967189") // Careful: this will silently overflow: UInt256(4294967189)
        
        curve = ECurve(field: FiniteField.PrimeField(p: p), gX: FiniteField.PrimeField(p: p).int(1244414049), gY: FiniteField.PrimeField(p: p).int(UInt256(decimalStringValue: "2415436385")), a: 0, b: 7, n: UInt256(decimalStringValue: "429496719"), h: nil)
        
        var double = curve[1252069803, 278016963]
        
        XCTAssertTrue(double.curve.G.x!.value == 1244414049)
        XCTAssertTrue(double.curve.G.y!.value ==  UInt256(decimalStringValue: "2415436385"))
        
        var result = 2 * curve.G
        XCTAssertTrue(result == double, result.description);
        
        var a = curve[978329252, 1]
        double = curve[2015765350, 2147483445]
        result = 2 * a
        XCTAssertTrue(result == double, result.description);

    }
    
    func testAdd32Bit() {
        let p = UInt256(decimalStringValue: "4294967189")
        
        curve = ECurve(field: FiniteField.PrimeField(p: p), gX: FiniteField.PrimeField(p: p).int(1244414049), gY: FiniteField.PrimeField(p: p).int(UInt256(decimalStringValue: "2415436385")), a: 0, b: 7, n: UInt256(decimalStringValue: "429496719"), h: nil)
        
        var a = curve[1130481541, 1353125538]
        var sum  = curve[UInt256(decimalStringValue: "3531337424"), UInt256(decimalStringValue: "137601932")]
        
        var result = curve.G + a
        
        XCTAssertTrue(result == sum, result.description);
        
        a = curve[978329252, 1]
        let b = curve[2015765350, 2147483445] // 2 * a
        sum = curve[UInt256(decimalStringValue: "2661831627"), UInt256(decimalStringValue: "2993780686")]    // 3 * a
        
        result = a + b
        XCTAssertTrue(result == sum, result.description);

    }
    
    func testDoubleBig() {
        curve = ECurve(domain: .Secp256k1)
        
        let a = curve.G
        let x = UInt256(0xc6047f94, 0x41ed7d6d, 0x3045406e,0x95c07cd8,0x5c778e4b,0x8cef3ca7,0xabac09b9,0x5c709ee5)
        let y = UInt256(0x1ae168fe, 0xa63dc339, 0xa3c58419, 0x466ceaee, 0xf7f63265, 0x3266d0e1, 0x236431a9, 0x50cfe52a)
        let doubleX = FFInt(x, curve.field)
        let doubleY = FFInt(y, curve.field)
        
        XCTAssertTrue(doubleX.value.toDecimalString == "89565891926547004231252920425935692360644145829622209833684329913297188986597" && doubleY.value.toDecimalString == "12158399299693830322967808612713398636155367887041628176798871954788371653930", "")
        
        let double = ECPoint(x: doubleX, y: doubleY, curve: curve)

        // Check if the points curve parameters are what they should be:
        XCTAssertTrue(a.curve.G.x!.value.toHexString ==   "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", a.curve.G.x!.value.toHexString)
        XCTAssertTrue(a.curve.G.y!.value.toHexString  == "483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8", a.curve.G.y!.value.toHexString)

        let result = 2 * a
        
        XCTAssertTrue(result == double, result.description);
    }
    
    func testAddBig() {
        // G + 2G
        curve = ECurve(domain: .Secp256k1)
        
        let a = curve.G
        
        let bX = FFInt(dec: "89565891926547004231252920425935692360644145829622209833684329913297188986597", curve.field)
        let bY = FFInt(dec: "12158399299693830322967808612713398636155367887041628176798871954788371653930", curve.field)
        
        let b = ECPoint(x: bX, y: bY, curve: curve)

        
        let sumX = FFInt(dec: "112711660439710606056748659173929673102114977341539408544630613555209775888121", curve.field)
        let sumY = FFInt(dec:  "25583027980570883691656905877401976406448868254816295069919888960541586679410", curve.field)
        
        let sum = ECPoint(x: sumX, y: sumY, curve: curve)
        
        let result = a + b
        
        XCTAssertTrue(result == sum, result.description);
    }

    
// Ambition:  < 1 second on iPhone 4S (currently 3.4 seconds on a MacBook Pro)
    
    func testMultiplyBig() {
        curve = ECurve(domain: .Secp256k1)

        let a = UInt256(decimalStringValue: "19898843618908353587043383062236220484949425084007183071220218307100305431102")

        let b = curve.G

        let productX = FFInt(dec: "83225686012142088543596389522774768397204444195709443235253141114409346958144", curve.field)
        let productY = FFInt(dec: "23739058578904784236915560265041168694780215705543362357495033621678991351768", curve.field)

        let product = ECPoint(x: productX, y: productY, curve: curve)

        
        let result = a * b
        
        XCTAssertTrue(result == product, result.description);
    }
}