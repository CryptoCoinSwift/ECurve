//
//  ECurve.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 26-06-14.

//import CryptoCoin

struct ECurve {
    let domain: EllipticCurveDomain
    
    init(domain: EllipticCurveDomain) {
        self.domain = domain
    }
}

func == (lhs: ECurve, rhs: ECurve) -> Bool {
    return lhs.domain == rhs.domain
}

