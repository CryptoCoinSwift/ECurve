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

func - (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't subtract integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        // Can't use UInt256's substract method, because it doesn't allow overflow
        //   let diff = (lhs.value - rhs.value) % p
        
        let (overflowDiff, didOverflow) = UInt256.subtract(lhs.value, rhs: rhs.value, allowOverFlow: true)
                
        if didOverflow {
            return field.int((overflowDiff % p + ((p - 1) - (UInt256.max % p))) % p)

        } else {
            return field.int(overflowDiff % p)
        }
    }
}

func * (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't multiply integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        let product = (lhs.value * rhs.value) % p
        return field.int(product)
    }
    
}

func / (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't divide integers from different fields")
    assert(lhs.value == 1, "Only inverse (1/x) supported")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        // Extremely inefficient algoritm:
        for var i = UInt256.allZeros;  i < UInt256.max; i++ {
            let one = field.int(UInt256([0,0,0,0,0,0,0,1]))
            if rhs * field.int(i) == one {
                return field.int(i)
            }
        }
        
        assert(false, "Inverse not found")

        return field.int(UInt256.allZeros)
    }
    
}

func / (lhs: Int, rhs: FFInt) -> FFInt {
    assert(lhs == 1, "Only inverse (1/x) supported")
    
    return rhs.field.int(1) / rhs
}


