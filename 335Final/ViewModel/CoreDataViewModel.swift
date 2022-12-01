//
//  CoreDataManager.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/29/22.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject
{
    
    let container: NSPersistentContainer
    @Published var savedUser: [User] = []
    
    init()
    {
        
        container = NSPersistentContainer(name: "Users")
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                
                print("error \(error)")
                
            }
            else
            {
                
                print("success")
                
            }
            
        }
        fetchUser()
        
    }
    
    func fetchUser()
    {
        
        let request = NSFetchRequest<User>(entityName: "User")
        
        do {
            
            savedUser = try container.viewContext.fetch(request)
            
        } catch let error
        {
            
            print("error, \(error)")
            
        }
        
    }
    
    func addUser(text: String)
    {
        
        let newUser = User(context: container.viewContext)
        newUser.id = text
        saveData()
        
    }
    
    func saveData()
    {
        
        do {
            
            try container.viewContext.save()
            
        } catch let error {
            
            print("error, \(error)")
            
        }
        
    }
    
}

