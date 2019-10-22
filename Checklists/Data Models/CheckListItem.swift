//
//  CheckListItem.swift
//  Checklists
//
//  Created by Eric Nguyen on 9/14/19.
//  Copyright © 2019 Eric Nguyen. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
