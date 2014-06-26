//
//  FiniteFieldInteger.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// Perform integer calculations on a finite field. E.g. addition is always modulo.

struct FFInt : Printable, Equatable {
    let field: FiniteField
    let value: UInt256
    
    init(value: UInt256, field: FiniteField) {
        self.value = value
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

func + (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't add integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let sum = (lhs.value + rhs.value) % p
        return field.int(sum)
    }

}

