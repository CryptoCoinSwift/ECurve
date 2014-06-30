//
//  UInt256Tests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.
//
//  Example field from https://github.com/cryptocoinjs/ecurve/blob/master/test/curve.js

import XCTest
import CryptoCoin

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
        
        XCTAssertEqual(a * b, product, product.description);
    }
    
    func testInverse() {
        let p = FiniteField.PrimeField(p: 11)
        let a = p.intWithDec("5")
        
        let inverse = p.intWithDec("9") // 9  * 5 = 45 -> 45 % 9 = 1
        
//        XCTAssertEqual(1 / a, inverse, inverse.description);
    }
    

    
}
