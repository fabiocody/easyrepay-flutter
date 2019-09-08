//
//  TransactionDetail.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionDetail: View {
            
    @Binding var typeSelection: Int
    @Binding var amount: Double
    @Binding var note: String
    @Binding var date: Date
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Type")
                        .font(.headline)
                        .padding(.leading, 20)
                    Picker(selection: $typeSelection, label: Text("")) {
                        ForEach(0..<TransactionType.allCases.count) {
                            Text(TransactionType.allCases[$0].rawValue).tag($0)
                        }
                    }
                    .foregroundColor(Color.primary)
                    .pickerStyle(WheelPickerStyle())
                    .accentColor(.green)
                    .frame(width: nil, height: 80, alignment: .center)
                    .padding()
                    .background(Color.secondary.opacity(0.35))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Amount")
                        .font(.headline)
                        .padding(.leading, 20)
                    TextField("Enter amount", value: $amount, formatter: numberFormatter)
                        .keyboardType(.numbersAndPunctuation)
                        .padding()
                        .background(Color.secondary.opacity(0.35))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Note")
                        .font(.headline)
                        .padding(.leading, 20)
                    TextField("Enter note", text: $note)
                        .padding()
                        .background(Color.secondary.opacity(0.35))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    Text("Date")
                        .font(.headline)
                        .padding(.leading, 20)
                    DatePicker(selection: $date, label: {Text("")})
                        .padding()
                        .background(Color.secondary.opacity(0.35))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
    }
    
}


struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetail(typeSelection: .constant(0), amount: .constant(0), note: .constant(""), date: .constant(Date()))
            .environment(\.colorScheme, .light)
    }
}
