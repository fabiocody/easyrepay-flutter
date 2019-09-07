//
//  TransactionDetailView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionDetailView: View {
    var transaction: Transaction
    var body: some View {
        TransactionDetail(transaction: transaction)
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transaction: Transaction())
    }
}
