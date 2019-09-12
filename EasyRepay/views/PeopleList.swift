//
//  PeopleList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PeopleList: View {
    
    @ObservedObject var store = dataStore
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            Group {
                if store.people.isEmpty {
                    Text("Nothing to show here")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(store.people) { person in
                            NavigationLink(destination: TransactionsList(person: person)) {
                                PersonRow(person: person)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .navigationBarTitle(Text("EasyRepay"))
            .navigationBarItems(
                leading: Button(action: {
                    self.showSettings = true
                }) {
                    HStack {
                        Image(systemName: "gear")
                            .font(.title)
                        Text("Settings")
                    }
                },
                trailing: Button(action: {
                    withAnimation { self.store.people.append(Person(name: "")) }
                }) {
                    HStack {
                        Text("New person")
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            )
            .sheet(isPresented: self.$showSettings, content: {SettingsView()})
        }
        .accentColor(.green)
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]
    }
    
    func delete(at offsets: IndexSet) {
        store.people.remove(atOffsets: offsets)
        store.save()
    }
    
}


struct PeopleList_Previews: PreviewProvider {
    static var previews: some View {
        PeopleList()
            .environment(\.colorScheme, .light)
    }
}
