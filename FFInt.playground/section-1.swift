// Select ECurveMacFlat as the scheme and build
import ECurveFlat

let field: FiniteField = .PrimeField(p: 11)
let a = field.int(9)
a.description

let b = field.int(4)

// Adding two numbers returns the sum modulo 11.
(a + b).description
(9 + 4) % 11

// Same for multiplication
(a * b).description
(9 * 4) % 11

// Mod inverse:
(1 / a).description
((1/a) * a).description