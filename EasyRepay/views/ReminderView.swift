//
//  ReminderView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct ReminderView: View {
    var person: Person
    var body: some View {
        Text("ReminderView")
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(person: peopleStore.people[0])
    }
}
