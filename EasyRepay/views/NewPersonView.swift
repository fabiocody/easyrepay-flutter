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
            ScrollView {
                VStack(alignment: .center) {
                    Image(systemName: "person.fill")    // TODO: Make bigger
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.secondary)
                        .imageScale(.large)
                        .padding(.top, 75)
                        .padding(.bottom, 20)
                    TextField("Enter name", text: $name, onCommit: commit)
                        .textContentType(.givenName)
                        .keyboardType(.default)
                        .padding()
                        .background(Color.secondary.opacity(0.35))
                        .cornerRadius(5.0)
                        .padding(.bottom, 15)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    Button("Insert", action: commit)
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
    
    func commit() {
        let p = Person(name: self.name == "" ? "New person" : self.name)
        peopleStore.people.append(p)
        peopleStore.people.sort(by: {$0.name < $1.name})
        peopleStore.save()
        self.name = ""
        self.presentationMode.wrappedValue.dismiss()
    }
    
}


struct NewPersonView_Previews: PreviewProvider {
    static var previews: some View {
        NewPersonView()
            .environment(\.colorScheme, .light)
    }
}
