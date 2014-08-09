// This doesn't work yet...

// Select ECurveMac - My Mac as the target and build
import ECurve
import UInt256

let field: FiniteField = FiniteField.PrimeField(p: 11)

let curve: ECurve = ECurve(field: FiniteField.PrimeField(p: 11), gX: FiniteField.PrimeField(p: 11).int(8), gY: FiniteField.PrimeField(p: 11).int(6), a: UInt256(1), b: UInt256(0), n: UInt256(12), h: nil)

