//
//  FiniteFieldInteger.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// Perform integer calculations on a finite field. E.g. addition is always modulo.

import UInt256

struct FFInt : Printable, Equatable {
    let field: FiniteField
    let value: UInt256
    
    init(value: UInt256, field: FiniteField) {
        self.value = value
        self.field = field
    }
    
    init(_ hex: String, _ field: FiniteField) {
        self.value = UInt256(hexStringValue: hex)
        self.field = field
    }
    
    init(dec: String, _ field: FiniteField) {
        self.value = UInt256(decimalStringValue: dec)
        self.field = field
    }
    
    // For testing with smaller values: takes two integers and assumes a Prime Field.
    init(val: Int, p: Int) {
        self.value = UInt256(decimalStringValue: val.description)
        self.field = .PrimeField(p: UInt256(decimalStringValue: p.description))
    }
    
    var description: String {
        return "\( value ) in \( field )"
    }
}

func == (lhs: FFInt, rhs: FFInt) -> Bool {
    return lhs.field == rhs.field && lhs.value == rhs.value
}

@prefix func - (rhs: FFInt) -> FFInt {
    let field = rhs.field
    switch field {
    case let .PrimeField(p):
        return field.int(0) - rhs
    }}

func + (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't add integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let sum = (lhs.value + rhs.value) % p
        return field.int(sum)
    }

}

func - (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't subtract integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let result = lhs.value &- rhs.value
                
        if rhs.value > lhs.value { // Overflow
            return field.int((result % p + ((p - 1) - (UInt256.max % p))) % p)

        } else {
            return field.int(result % p)
        }
    }
}

func * (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't multiply integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let product: (UInt256, UInt256) = lhs.value * rhs.value
        
        return field.int(product % p.p)
    }
    
}

func / (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't divide integers from different fields")
    
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let inverse: UInt256 = rhs.value.modInverse(p.p)
        let (a,b) = lhs.value * inverse
        let res: UInt256 = (a,b) % p.p
        
        return field.int(res)
    }
    
}

func / (lhs: Int, rhs: FFInt) -> FFInt {
    assert(lhs >= 0, "Positive integer expected")
    
    if lhs == 0 {
        return rhs.field.int(0)
    }
    
    let inverse = rhs.field.int(1) / rhs
    if lhs == 1 {
        return inverse
    } else {
        return rhs.field.int(UInt256(lhs)) * inverse
    }
}


