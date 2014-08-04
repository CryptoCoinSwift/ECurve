//
//  FiniteFieldInteger.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// Perform integer calculations on a finite field. E.g. addition is always modulo.

#if os(OSX)
import UInt256
#endif

public struct FFInt : Printable, Equatable {
    public let field: FiniteField
    public let value: UInt256
    
    public init(_ value: UInt256, _ field: FiniteField) {
        self.value = value
        self.field = field
        
        switch field {
        case let .PrimeField(p):
            assert(value < p.p, "Input value must be smaller than p")
        }
    }
    
    public init(_ hex: String, _ field: FiniteField) {
        self.value = UInt256(hexStringValue: hex)
        self.field = field
        
        switch field {
        case let .PrimeField(p):
            assert(self.value < p.p, "Input value must be smaller than p")
        }
    }
    
    public init(dec: String, _ field: FiniteField) {
        self.value = UInt256(decimalStringValue: dec)
        self.field = field
        
        switch field {
        case let .PrimeField(p):
            assert(self.value < p.p, "Input value must be smaller than p")
        }
    }
    
    // For testing with smaller values: takes two integers and assumes a Prime Field.
    public init(val: Int, p: Int) {
        self.value = UInt256(decimalStringValue: val.description)
        self.field = .PrimeField(p: UInt256(decimalStringValue: p.description))
        
        switch field {
        case let .PrimeField(p):
            assert(self.value < p.p, "Input value must be smaller than p")
        }
    }
    
    public var description: String {
        return "\( value ) in \( field )"
    }
}

public func == (lhs: FFInt, rhs: FFInt) -> Bool {
    return lhs.field == rhs.field && lhs.value == rhs.value
}

prefix public  func - (rhs: FFInt) -> FFInt {
    let field = rhs.field
    switch field {
    case let .PrimeField(p):
        assert(rhs.value < p.p, "Input value must be smaller than p")
        return field.int(0) - rhs
    }}

public func + (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't add integers from different fields")
    
    if (rhs.value == 0) { return lhs }
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        assert(lhs.value < p.p, "Input value must be smaller than p")
        assert(rhs.value < p.p, "Input value must be smaller than p")

        let rhsMod = p.p - rhs.value
        
        
        if (lhs.value >= rhsMod) {
            return field.int(lhs.value - rhsMod)
        } else {
            return field.int(p.p - rhsMod + lhs.value)
        }
    }

}

public func - (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't subtract integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        assert(lhs.value < p.p, "Input value must be smaller than p")
        assert(rhs.value < p.p, "Input value must be smaller than p")
        
        if(lhs.value >= rhs.value) {
            return field.int(lhs.value - rhs.value)
        } else {
            return field.int(p.p - rhs.value + lhs.value )

        }
    }
}

 public func ^^ (lhs: FFInt, rhs: Int) -> FFInt {
    switch lhs.field {
    case let .PrimeField(p):
        assert(lhs.value < p.p, "Input value must be smaller than p")
    }
    
    switch rhs {
    case 0:
        return lhs.field.int(1)
    case 1:
        return lhs
    case let k where k > 1:
        var res = lhs
        for i in 1..<k {
            res *= lhs
        }
        return res
    case let k where k < 0:
        assert(false, "Negative power not supported")
        return lhs.field.int(0)
        
    default:
        assert(false, "Logical error")
        return lhs.field.int(0)

    }
}

public func * (lhs: Int, rhs: FFInt) -> FFInt {
    let lhsInt: UInt256 = UInt256(UInt32(lhs))
    return rhs.field.int(lhsInt) * rhs
}

public func * (lhs: UInt256, rhs: FFInt) -> FFInt {
    return rhs.field.int(lhs) * rhs
}

public func * (lhs: FFInt, rhs: UInt256) -> FFInt {
    return lhs * lhs.field.int(rhs)
}

public func *= (inout lhs: FFInt, rhs: FFInt) -> () {
    lhs = lhs * rhs
}

public func * (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't multiply integers from different fields")
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        assert(lhs.value < p.p, "Input value must be smaller than p")
        assert(rhs.value < p.p, "Input value must be smaller than p")

        let product: (UInt256, UInt256) = lhs.value * rhs.value
        
        return field.int(product % p.p)
    }
    
}

public func / (lhs: FFInt, rhs: FFInt) -> FFInt {
    assert(lhs.field == rhs.field, "Can't divide integers from different fields")
    
    
    let field = lhs.field
    switch field {
    case let .PrimeField(p):
        assert(lhs.value < p.p, "Input value must be smaller than p")
        assert(rhs.value < p.p, "Input value must be smaller than p")
                
        let inverse: UInt256 = rhs.value.modInverse(p.p)
        
        return lhs * inverse
    }
    
}

public func / (lhs: Int, rhs: FFInt) -> FFInt {
    assert(lhs >= 0, "Positive integer expected")
   
    let lhsInt: UInt256 = UInt256(UInt32(lhs))

    return rhs.field.int(lhsInt) / rhs

}


