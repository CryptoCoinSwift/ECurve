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
        let a = FFInt(value: UInt256(decimalStringValue: "5"), field: FiniteField.PrimeField(p: 11))
        
        XCTAssertTrue(a != nil, "Should exist");
    }
    
    func testEquality() {
        let a =  FFInt(value: UInt256(    hexStringValue: "5"), field: FiniteField.PrimeField(p: 11))
        let b =  FFInt(value: UInt256(decimalStringValue: "5"), field: FiniteField.PrimeField(p: 11))
        
        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testInitWithDecimalStringAndP() {
        let a = FFInt(value: UInt256(decimalStringValue: "5"), field: FiniteField.PrimeField(p: 11))
        let b = FFInt(val: 5, p: 11)
        
        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testInitFromField() {
        let a = FFInt(value: UInt256(decimalStringValue: "5"), field: FiniteField.PrimeField(p: 11))
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
        let p = FiniteField.PrimeField(p: UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF43"))
        
        let a = p.int(UInt256(hexStringValue: "8888888888888888888888888888888888888888888888888888888888888888"))
        let b = p.intWithDec("2")
        
       // 2 *
       //     0x   8888888888888888888888888888888888888888888888888888888888888888 =
       //     0x 1 1111111111111111111111111111111111111111111111111111111111111110
       // Modulo 2^256 - 189:
       //     0x   11111111111111111111111111111111111111111111111111111111111111cd
        
        let product = p.int(UInt256(hexStringValue: "11111111111111111111111111111111111111111111111111111111111111cd"))
        
        XCTAssertEqual(a * b, product, product.description);
    }
    
    func testMultiplyBigRemainder() {
        // This will take forever if you search the modulo by subtracting
        // p from the remainder in a loop.
    
        let p = FiniteField.PrimeField(p: UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F"))
        
        let a = p.int(UInt256(hexStringValue: "6D3B337CED96330500E127C16B95211507D3F691896A7A8C0DD7841244E84A99"))
    
        let b = p.int(UInt256(hexStringValue: "79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"))
 
        let (productTupleLeft, productTupleRight) = (UInt256(hexStringValue: "33F23902074835C68CC1630F5EA81161C3720765CC78C137D6434422659760CC"),UInt256(hexStringValue: "493EF0F253A03B4AB649EA632C432258F7886805422976F65A3E63DE32D809D8"))
    
        let (resLeft, resRight) = a.value * b.value
        
        XCTAssertTrue(resLeft == productTupleLeft && resRight == productTupleRight, "");
        
        let product = p.int(UInt256(hexStringValue: "8FF2B776AAF6D91942FD096D2F1F7FD9AA2F64BE71462131AA7F067E28FEF8AC"))
    
        let result = a * b
        
        XCTAssertTrue(result == product, result.description);

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
