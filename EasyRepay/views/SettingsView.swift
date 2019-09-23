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
    
    @State var showActionSheet = false
    
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
                Button(action: {}) {    // TODO: Show URL
                    Text("Privacy notice")
                }
                Button(action: {self.showActionSheet = true}) {
                    Text("Delete all data")
                        .foregroundColor(.red)
                }
            }
            Section(footer: SettingsFooter()) {
                EmptyView()
            }
        }
        .navigationBarTitle("Settings")
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Do you really want to delete all your data?"),
                        message: Text("This action cannot be undone."),
                        buttons: [.destructive(Text("Delete all"), action: dataStore.deleteAll), .cancel()])
        }
    }
    
}


struct SettingsFooter: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("EasyRepay")
                Text("v\(UIApplication.appVersion!) (\(UIApplication.appBuild!))")
            }
            Spacer()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
