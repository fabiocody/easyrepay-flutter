//
//  PeopleList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct PeopleList: View {
    @State private var showAdd = false
    @State private var showSettings = false
    @State private var showActions = true
    
    private var newPerson: Person? = nil
    
    var body: some View {
        NavigationView {
            List(peopleStore.people, id: \.id) { person in
                NavigationLink(destination: TransactionsList(person: person)) {
                    PersonRow(person: person)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("EasyRepay"))
            .navigationBarItems(
                /*leading: Button(action: {self.showSettings = true}) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.large)
                        Text("Settings")
                    }
                },*/
                trailing: Button(action: {
                    self.showAdd = true
                }) {
                    HStack {
                        Text("New person")
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            )
            //.sheet(isPresented: self.$showSettings, content: {SettingsView()})
            .sheet(isPresented: self.$showAdd, content: {NewPersonView()})
        }
        .accentColor(.green)
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        //UINavigationBar.appearance().backgroundColor = .systemGreen
    }
}

struct PeopleList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeopleList()
                .environment(\.colorScheme, .dark)
            PeopleList()
                .environment(\.colorScheme, .light)
        }
    }
}
