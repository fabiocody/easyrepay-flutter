//
//  SettingsView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 12/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings = dataStore.settings
    
    var body: some View {
        Form {
            Section(header: Text("Sync")) {
                Toggle("iCloud", isOn: $settings.icloud.animation())
                if settings.icloud {
                    Text("iCloud sync is not working at the moment.")
                        .foregroundColor(.red)
                }
            }
            Section {
                Button(action: {}) {
                    Text("Privacy notice")
                }
                Button(action: dataStore.deleteAll) {   // TODO: alert
                    Text("Delete all data")
                        .foregroundColor(.red)
                }
            }
            Section(footer: SettingsFooter()) {
                EmptyView()
            }
        }
        .navigationBarTitle("Settings")
        // TODO SAVE
    }
}


struct SettingsFooter: View {
    var body: some View {
        HStack {
            Spacer()
            Text("EasyRepay")
            Spacer()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
