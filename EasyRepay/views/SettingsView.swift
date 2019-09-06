//
//  SettingsView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 06/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    Text("Some setting")
                }
                Section {
                    Text("Some setting")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: {self.presentationMode.wrappedValue.dismiss()}).accentColor(.green))
            .accentColor(.green)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
