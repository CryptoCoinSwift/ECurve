# Find R⁻¹ and M' for R = 2²⁵⁶ and M = 2²⁵⁶ - 2³² - 2⁹ - 2⁸ - 2⁷ - 2⁶ - 2⁴ - 1
# Using the binary extended GCD Operation on page 4 of:
# http://www.hackersdelight.org/MontgomeryMultiplication.pdf
# These two values could be useful when performing multiplications modulo the 
# prime used in secp256k1.

R = 2**256
M = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f

alpha = R
beta = M

u = 2
v = 0

# Invariant: R = u * alpha - v * alpha

while (alpha > 0) do
  alpha = alpha >> 1
  if ((u & 1) == 0)
    u = u >> 1
    v = v >> 1
  else
    u = (u + beta) >> 1
    v = (v >> 1) + alpha
  end
end

puts "R⁻¹ = #{ u.to_s(16) }" 
puts "M' = #{ v.to_s(16) }"

puts "(R R⁻¹ - M M' ) % M = #{ (R * u - M * v) % M }"