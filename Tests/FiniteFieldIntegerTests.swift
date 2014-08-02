//
//  UInt256Tests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//
//  Example field from https://github.com/cryptocoinjs/ecurve/blob/master/test/curve.js

import XCTest
import ECurve
import UInt256

class FFIntTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let a = FFInt(UInt256(5), FiniteField.PrimeField(p: 11))
        
        XCTAssertTrue(a != nil, "Should exist");
    }
    
    func testEquality() {
        let a =  FFInt(UInt256(5), FiniteField.PrimeField(p: 11))
        let b =  FFInt(UInt256(5), FiniteField.PrimeField(p: 11))
        
        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testInitWithDecimalStringAndP() {
        let a = FFInt(UInt256(5), FiniteField.PrimeField(p: 11))
        let b = FFInt(val: 5, p: 11)
        
        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testInitFromField() {
        let a = FFInt(UInt256(decimalStringValue: "5"), FiniteField.PrimeField(p: 11))
        let field = FiniteField.PrimeField(p: 11)
        let b = field.intWithDec("5")
        
        XCTAssertTrue(a == b, "Should be the same");
    }
    


    func testAdd() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        let b = p.intWithDec("8")
        
        let sum = p.intWithDec("2") // 5 + 8 = 13 -> 13 % 11 = 2
        
        XCTAssertEqual(a + b, sum, sum.description);

    }
    
    func testAddBigger() {
        var field = FiniteField.PrimeField(p: 65447)
        
        var a = field.intWithDec("35301")
        var b = field.intWithDec("1389")
        var sum = field.intWithDec("36690")
        XCTAssertEqual(a + b, sum, sum.description);
        
        // This should crash:
//        a = p.intWithDec("65448") // > p
//        b = p.intWithDec("1")
//        a + b
        
        field = EllipticCurveDomain.Secp256k1.field
        
        a =   field.int(UInt256(0x9b992796, 0x19237faf, 0x0c13c344, 0x614c46a9, 0xe7357341, 0xc6e4e042, 0xa9b1311a, 0x8622deaa))
        
        b =   field.int(UInt256(0xe7f1caa6, 0x36baa277, 0x9cfd6cf9, 0x696cf826, 0xf013db03, 0x7aa08f3d, 0x5c2dfaf9, 0xdb5d255b))
        
        // a + b > p
        
        sum = field.int(UInt256(0x838af23c, 0x4fde2226, 0xa911303d, 0xcab93ed0, 0xd7494e45, 0x41856f80, 0x05df2c15, 0x618007d6))
        
        XCTAssertEqual(a + b, sum, sum.description);

    }
    
    func testSubtract() {
        let p = FiniteField.PrimeField(p: 11)
        var a = p.intWithDec("2")
        var b = p.intWithDec("5")
        
        var diff = p.intWithDec("8") // 2 - 5 = -3 -> -3 % 11 = 8
        
        XCTAssertEqual(a - b, diff, "\(a.value) - \(b.value) = \(diff.value) != \( (a - b).value)");
        
        a = p.intWithDec("3")
        b = p.intWithDec("10")
        
        diff = p.intWithDec("4")
        
        XCTAssertEqual(a - b, diff, "\(a.value) - \(b.value) = \(diff.value) != \( (a - b).value)");
    }
    
    func testSubtractBigger() {
        var field = FiniteField.PrimeField(p: 65447)
        var a = field.intWithDec("36690")
        var b = field.intWithDec("1389")
        
        var diff = field.intWithDec("35301")
        var result = a - b
        
        XCTAssertEqual(result, diff, result.description);
        
        a = field.intWithDec("1389")
        b = field.intWithDec("36690")
        
        diff = field.intWithDec("30146")
        
        result = a - b
        
        XCTAssertEqual(result, diff, result.description);
        
        field = EllipticCurveDomain.Secp256k1.field
        
        a = field.int(UInt256(0x838af23c, 0x4fde2226, 0xa911303d, 0xcab93ed0, 0xd7494e45, 0x41856f80, 0x05df2c15, 0x618007d6))
        
        b =   field.int(UInt256(0xe7f1caa6, 0x36baa277, 0x9cfd6cf9, 0x696cf826, 0xf013db03, 0x7aa08f3d, 0x5c2dfaf9, 0xdb5d255b))
        
        diff = field.int(UInt256(0x9b992796, 0x19237faf, 0x0c13c344, 0x614c46a9, 0xe7357341, 0xc6e4e042, 0xa9b1311a, 0x8622deaa))
        
        result = a - b
        
        XCTAssertEqual(result, diff, result.description);

    }

    func testMultiply() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        let b = p.intWithDec("8")
        
        let product = p.intWithDec("7") // 5 * 8 = 40 -> 40 % 11 = 7
        let result = a * b
        
        
        XCTAssertEqual(result, product, result.description);
    
    }
    
    func testMultiplyBig() {
        // 2^256 - 189 is prime.
        let field = FiniteField.PrimeField(p: UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF43"))
        
        let a = field.int(UInt256(hexStringValue: "8888888888888888888888888888888888888888888888888888888888888888"))
        let b = field.intWithDec("2")
        
       // 2 *
       //     0x   8888888888888888888888888888888888888888888888888888888888888888 =
       //     0x 1 1111111111111111111111111111111111111111111111111111111111111110
       // Modulo 2^256 - 189:
       //     0x   11111111111111111111111111111111111111111111111111111111111111cd
        
        let product = field.int(UInt256(hexStringValue: "11111111111111111111111111111111111111111111111111111111111111cd"))
        
        XCTAssertEqual(a * b, product, product.description);

        
        
    }
    
    func testMultiplyBigRemainder() {
        // This will take forever if you search the modulo by subtracting
        // p from the remainder in a loop.
    
        var field = FiniteField.PrimeField(p: UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F"))
        
        var a = field.int(UInt256(hexStringValue: "6D3B337CED96330500E127C16B95211507D3F691896A7A8C0DD7841244E84A99"))
    
        var b = field.int(UInt256(hexStringValue: "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"))
 
        let (productTupleLeft, productTupleRight) = (UInt256(hexStringValue: "33F23902074835C68CC1630F5EA81161C3720765CC78C137D6434422659760CC"),UInt256(hexStringValue: "493EF0F253A03B4AB649EA632C432258F7886805422976F65A3E63DE32D809D8"))
    
        let (resLeft, resRight) = a.value * b.value
        
        XCTAssertTrue(resLeft == productTupleLeft && resRight == productTupleRight, "");
        
        var product = field.int(UInt256(hexStringValue: "8FF2B776AAF6D91942FD096D2F1F7FD9AA2F64BE71462131AA7F067E28FEF8AC"))
    
        var result = a * b
        
        XCTAssertTrue(result == product, result.description);
    }
    
    func testMultiply128bit() {
        let p = UInt256(0,0,0,0,0xffffffff, 0xffffffff, 0xffffffff, 0xfffffeed) // 2^128 - 275
        
        let field: FiniteField = .PrimeField(p: p)
        
        
        var a = field.int(UInt256(0,0,0,0,0x1344e31a, 0x1645f901, 0x76a5a69a, 0x167177a9))
        
        XCTAssertTrue(a.value.toDecimalString == "25613014280099286157844823542630283177", a.value.toDecimalString)
        
        var b = field.int(UInt256(0,0,0,0,0xf2077f07, 0x0e8ff5f2, 0xe1051bce, 0xae8585f6))
        
        
        XCTAssertTrue(b.value.toDecimalString == "321712097483083014387933714960710206966", b.value.toDecimalString)
        
        var product = field.int(UInt256(0,0,0,0,0x28fd4945, 0xfd22c3e9, 0x3a4fd031, 0xe4ce828c))
        
        XCTAssertTrue(product.value.toDecimalString == "54484257097591962488775274510905410188", product.value.toDecimalString)
        
        var result = a * b
        
        XCTAssertTrue(result == product, result.description);
        
    }
    
//    func testMultiply135bit() { // Requires a tuple of UInt256 for the intermediate product
//        let p = UInt256(0,0,0,0,0xffffffff, 0xffffffff, 0xffffffff, 0xfffffeed) // 2^128 - 275
//        
//        let field: FiniteField = .PrimeField(p: p)
//        
//        
//        var a = field.int(UInt256(0,0,0,0,0x1344e31a, 0x1645f901, 0x76a5a69a, 0x167177a9))
//        
//        XCTAssertTrue(a.value.toDecimalString == "25613014280099286157844823542630283177", a.value.toDecimalString)
//        
//        var b = field.int(UInt256(0,0,0,0,0xf2077f07, 0x0e8ff5f2, 0xe1051bce, 0xae8585f6))
//        
//        
//        XCTAssertTrue(b.value.toDecimalString == "321712097483083014387933714960710206966", b.value.toDecimalString)
//        
//        var product = field.int(UInt256(0,0,0,0,0x28fd4945, 0xfd22c3e9, 0x3a4fd031, 0xe4ce828c))
//        
//        XCTAssertTrue(product.value.toDecimalString == "54484257097591962488775274510905410188", product.value.toDecimalString)
//        
//        var result = a * b
//        
//        XCTAssertTrue(result == product, result.description);
//        
//    }
    
    func testMultiplySecp256k1() {
        let field = EllipticCurveDomain.Secp256k1.field
        
        var a = field.int(UInt256(0x9b992796, 0x19237faf, 0x0c13c344, 0x614c46a9, 0xe7357341, 0xc6e4e042, 0xa9b1311a, 0x8622deaa))
        
         XCTAssertTrue(a.value.toDecimalString == "70379092346064318541386215347774848188860670239569790505179904651624764858026", a.value.toDecimalString)
        
        var b =   field.int(UInt256(0xe7f1caa6, 0x36baa277, 0x9cfd6cf9, 0x696cf826, 0xf013db03, 0x7aa08f3d, 0x5c2dfaf9, 0xdb5d255b))
        
        
        XCTAssertTrue(b.value.toDecimalString == "104911476799222965565363906294962636581662257028280315064396094226013674612059", b.value.toDecimalString)
        
        var product = field.int(UInt256(0x896cbfe5, 0xdd327035, 0x9b769bff, 0x82996a89, 0x9b57827b, 0xc19576ab, 0x11704459, 0x9336d1f0))
        
        XCTAssertTrue(product.value.toDecimalString == "62159004169578350069197270873198552845709123955558985861847306139118838665712", product.value.toDecimalString)
        
        var result = a * b

        XCTAssertTrue(result == product, result.description);
        
     
        var (left, right) = (UInt256(0x8cfa2912, 0x94cc8c2c, 0x827a9ef6, 0x977f6b69, 0x1d24b810, 0xf085c437, 0xabd13f27, 0x942da0b5), UInt256(0xede973cf, 0x7a14db61, 0x0dfe857e, 0x382bc650, 0x71af459e, 0x27425f0c, 0x36b67051, 0x0a55b86e))
        
        XCTAssertTrue(left.toDecimalString == "63765794040401514026575861164615535099083399945548297837938497193551900549301", left.toDecimalString)

        var (resLeft, resRight) = a.value * b.value
        // 7383574513814497347731124253804908375952170682808274416762638435971229279588205319424532844206978022789581507672975461171843856808649386561346601762535534 (Ruby and Sage)
        
        // 62159004169578350069197270871737050875922348555598422225414031658629658498497 left result
        // 63765794040401514026575861164615535099083399945548297837938497193551900549301 left target
        
        XCTAssertTrue(resLeft == left, resLeft.description);
        XCTAssertTrue(resRight == right, resRight.description);
    }

    
    func testInverse() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        
        let c: FFInt = p.intWithDec("9") // 9  * 5 = 45 -> 45 % 9 = 1
        
        var inverse: FFInt = p.int(1) / a
        
        XCTAssertEqual(inverse, c, c.description);
        
    }
    
    func testInverseSimplified() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        
        let c: FFInt = p.intWithDec("9") // 9  * 5 = 45 -> 45 % 9 = 1
        
        // Simplified form:
        var inverse = 1 / a
        XCTAssertEqual(inverse, c, inverse.description);
    }
    
    func testInverseBigger() {
        var field = FiniteField.PrimeField(p: 65447)
        var a = field.intWithDec("35301")
        
        var inverse = field.intWithDec("40487")
        
        var result: FFInt = 1 / a
        
        XCTAssertEqual(result, inverse, result.description);
        
        field = EllipticCurveDomain.Secp256k1.field
        
        a = field.int(UInt256(0x9b992796, 0x19237faf, 0x0c13c344, 0x614c46a9, 0xe7357341, 0xc6e4e042, 0xa9b1311a, 0x8622deaa))
        
        // To make typing easier, try this in Ruby:
        // 81499394833957831074978817131096643076996054158171543627174210231443581427004.to_s(16).chars.each_slice(8).map(&:join).join(", 0x")
        
        inverse = field.int(UInt256(0xb42f05d5, 0xf445d2ea, 0x49e61c6c, 0x570c93f7, 0x826ef85b, 0xd4d3f4ee, 0x913541c5, 0x5221dd3c))
        
        XCTAssertTrue(inverse.value.toDecimalString == "81499394833957831074978817131096643076996054158171543627174210231443581427004", inverse.value.toDecimalString)

        result = 1 / a
        
        XCTAssertEqual(result, inverse, result.description);
        
    }
    
    func testDivide() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        let b = p.intWithDec("2")
        
        let div: FFInt = p.intWithDec("7") // 2 * (1/5) ->
                                         // 1 / 5 = 9 
                                         // 2 * 9 = 18 -> 18 % 11 = 7
        
        var result: FFInt = b / a
        
        XCTAssertEqual(div, result, result.description);
        
        // Simplified form:
        result = 2 / a
        XCTAssertEqual(div, result, result.description);
        
    }
    

    
}
