//
//  Colors.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import SwiftUI


class Colors {
    
    static let secondaryGray = Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 1.0)
    
    static func amountColor(person: Person) -> Color {
        var sum = Double()
        for t in person.transactions {
            switch t.type {
                case .credit, .settleDebt:
                    sum += t.amount
                case .debt, .settleCredit:
                    sum -= t.amount
                default:
                    sum += 0.0
            }
        }
        if sum >= 0 {
            return .green
        } else {
            return .red
        }
    }
    
    static func amountColor(transaction: Transaction) -> Color {    // TODO: Change color code
        switch transaction.type {
            case .credit, .settleDebt:
                return .green
            case .debt, .settleCredit:
                return .red
            default:
                return .secondary
        }
    }
    
}
