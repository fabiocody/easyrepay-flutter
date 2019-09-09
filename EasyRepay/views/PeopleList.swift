//
//  PeopleList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PeopleList: View {
    
    @ObservedObject var store = peopleStore
    
    @State private var showAdd = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            Group {
                if store.people.isEmpty {
                    Text("Nothing to show here")    // TODO: Make alternative with List
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(store.people) { person in
                            NavigationLink(destination: TransactionsList(store: self.store, person: person)) {
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
                    self.showAdd = true
                }) {
                    HStack {
                        Text("New person")
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            )
            .sheet(isPresented: self.$showAdd, content: {NewPersonView()})
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
