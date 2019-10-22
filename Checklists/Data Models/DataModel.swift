//
//  DataModel.swift
//  Checklists
//
//  Created by Eric Nguyen on 10/11/19.
//  Copyright © 2019 Eric Nguyen. All rights reserved.
//

import Foundation

class DataModel {
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        // 1
        let encoder = PropertyListEncoder()
        // 2
        do {
            // 3
            let data = try encoder.encode(lists)
            // 4
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
            // 5
        catch {
            // 6
            print("Error encoding item array!")
        }
    }
    
    func loadChecklists() {
        // 1
        let path = dataFilePath()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            }
            catch {
                print("Error decoding item array!")
            }
        }
    }
    
    func registerDefaults() {
        let dictionary : [String:Any] = [ "ChecklistIndex": -1, "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "First Habit")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(
                checklist2.name) == .orderedAscending })
    }
}
