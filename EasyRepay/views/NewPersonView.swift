//
//  NewNameView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct NewPersonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Image(systemName: "person.fill")
                    .padding()
                    .foregroundColor(.secondary)
                    .imageScale(.large)
                    .padding(.top, 100)
                    .padding(.bottom, 20)
                TextField("Enter name", text: $name)
                    .padding()
                    .background(Color.secondary.opacity(0.35))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                Button("Insert", action: {
                    ModelHelper.insertPerson(name: self.name)
                    self.name = ""
                    self.presentationMode.wrappedValue.dismiss()
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 55)
                    .background(Color.green)
                    .cornerRadius(15.0)
                Spacer()
            }
            .padding()
            .navigationBarTitle("New person")
            .navigationBarItems(leading: Button("Cancel", action: {
                self.name = ""
                self.presentationMode.wrappedValue.dismiss()
            }).accentColor(.green))
        }
    }
    
}


struct NewPersonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewPersonView().environment(\.colorScheme, .light)
            NewPersonView().environment(\.colorScheme, .dark)
        }
    }
}
