//
//  PeopleList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PeopleList: View {
    
    @EnvironmentObject var data: UserData
        
    @State private var showAdd = false
    @State private var showSettings = false
    @State private var showActions = true
        
    var body: some View {
        NavigationView {
            List(data.store.people) { person in
                NavigationLink(destination: TransactionsList(person: person)) {
                    PersonRow(person: person)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("EasyRepay"))
            .navigationBarItems(
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
            .sheet(isPresented: self.$showAdd, content: {NewPersonView().environmentObject(self.data)})
        }
        .accentColor(.green)
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemGreen]
    }
    
}


struct PeopleList_Previews: PreviewProvider {
    static var previews: some View {
        PeopleList()
            .environment(\.colorScheme, .dark)
            .environmentObject(UserData())
    }
}
