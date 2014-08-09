// This doesn't work yet...

// Select ECurveMac - My Mac as the target and build
import ECurveFlat

let field: FiniteField = FiniteField.PrimeField(p: 11)
field.description

// Define your own curve:

let curve: ECurve = ECurve(field: FiniteField.PrimeField(p: 11), gX: FiniteField.PrimeField(p: 11).int(8), gY: FiniteField.PrimeField(p: 11).int(6), a: UInt256(1), b: UInt256(0), n: UInt256(12), h: nil)
curve.description

// Use a NIST curve:
ECurve(domain: .Secp256k1).description

// Points on a curve:
var a = curve[9,10]
var b = curve[5,3]
a.description

(a + b).description

// Infinity: P + ∞ = ∞ + P = P
let inf = curve.infinity
let P: ECPoint = curve[5,8]

(inf + P) == P

// Double a point:
a.double.description
(2 * a).description

// Multiply a point with an integer:
(3 * a).description

// Multiplying by 3 is achieved by doubling and adding:
(a + a.double).description

// Convert to Jacobian coordinates:
a.convertToJacobian()
b.convertToJacobian()
a.description

// Adding points using Jacobian coordinates is faster
var c = a + b
c.description

// But there is a cost when converting back
c.convertToAffine()
c.description