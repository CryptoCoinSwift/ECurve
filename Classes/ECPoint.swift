//
//  ECPoint.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

// List of methods that should be supported:
// http://cryptocoinjs.com/modules/crypto/ecurve/  (under Point)
// Use Swift style syntax where possible. E.g. not point.add(point), but point + point

import UInt256Mac

public struct ECPoint : Printable {
    public let curve: ECurve

    public enum Coordinate {
        case Affine(x: FFInt?, y: FFInt?)
        case Jacobian(X: FFInt, Y: FFInt, Z: FFInt)
    }
    
    public var coordinate: Coordinate
    
    public init(x: FFInt?, y: FFInt?, curve: ECurve) {
        self.curve = curve
        
        self.coordinate = .Affine(x: x, y:y)
    }
    
    //    http://nmav.gnutls.org/2012/01/do-we-need-elliptic-curve-point.html
    //    https://bitcointalk.org/index.php?topic=237260.0
    //
    //    init(compressedPointHexString: String, curve: ECurve) {
    //        self.curve = curve
    //
    //        self.x = UInt256(decimalStringValue: "0")
    //        self.y = UInt256(decimalStringValue: "0")
    //    }
    
    static public func infinity (curve: ECurve) ->  ECPoint {
        return ECPoint(x: nil, y: nil, curve: curve)
    }
    
    public var isInfinity: Bool {
        switch coordinate {
        case let .Affine(x,y):
            return x == nil && y == nil
        case .Jacobian:
            assert(false, "Not implemented")
            return false
        }
    }
    
    public var description: String {
        if self.isInfinity {
          return "Infinity"
        } else {
            switch coordinate {
            case let .Affine(x,y):
                return "(\(x!.value.description), \( y!.value.description ))"
            case .Jacobian:
                assert(false, "Not implemented")
                return ""
            }

        }
    }
}

public func == (lhs: ECPoint, rhs: ECPoint) -> Bool {
    
    switch (lhs.coordinate,rhs.coordinate) {
    case let (.Affine(x1,y1),.Affine(x2,y2) ):
        return lhs.curve == rhs.curve && x1 == x2 && y1 == y2
    case let (.Jacobian(X1,Y1,Z1),.Jacobian(X2,Y2,Z2)):
        return lhs.curve == rhs.curve && X1 == X2 && Y1 == Y2 && Z1 == Z2
    default:
        assert(false, "Comparing different coordinate systems is not implemented")
        return false
    }

}
