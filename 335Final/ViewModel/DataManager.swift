//
//  DataManager.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/28/22.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject
{
    
    @Published var history: [History] = []
    @Published var bookmarks: [Bookmarks] = []
    @StateObject var vm =  CoreDataViewModel()
    @Published var flag = false
    
    func fetchHistory() async
    {
        
        history.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection(vm.savedUser[0].id! + "-HISTORY")
        
        ref.getDocuments { snapshot, error in
            
            guard error == nil else
            {
                
                print(error!.localizedDescription)
                return
                
            }
            
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    let data = document.data()
                        
                    let id = data["id"] as? String ?? ""
                    let url = data["url"] as? String ?? ""
                    let docName = data["docName"] as? String ?? ""
                        
                    let hist = History(id: id, url: url, docName: docName)
                    self.history.append(hist)
                    
                }
                
                self.history = self.history.sorted(by: { $0.docName > $1.docName })
                
            }
            
        }
        
    }
    
    func addHistory(histUrl: String)
    {
        
        if(vm.savedUser[0].id != nil)
        {
            
            let db = Firestore.firestore()
            
            db.collection(vm.savedUser[0].id! + "-HISTORY").getDocuments()
            {
                (querySnapshot, err) in

                if let err = err
                {
                    print("Error getting documents: \(err)");
                }
                else
                {
                    var count = 0
                    for document in querySnapshot!.documents {
                        count += 1
                        print("\(document.documentID) => \(document.data())");
                    }
                    
                    let ref = db.collection(self.vm.savedUser[0].id! + "-HISTORY").document("\(count)")
                    
                    let docName = ref.documentID
                    
                    let randomID = Int.random(in: 1...1000000)
                    
                    let stringID = "\(randomID)"
                    
                    ref.setData(["url": histUrl, "id": stringID, "docName": "\(count)"]) { error in
                        
                        if let error = error {
                            
                            print(error.localizedDescription)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deleteHistory(docName: String)
    {
        
        let db = Firestore.firestore()
        
        let _: Void = db.collection(vm.savedUser[0].id! + "-HISTORY").document(docName).delete() { error in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            }
            
            
        }
        
    }
    
    func deleteAllHistory()
    {
        
        let db = Firestore.firestore()
        let ref = db.collection(vm.savedUser[0].id! + "-HISTORY")
        
        ref.getDocuments { snapshot, error in
            
            guard error == nil else
            {
                
                print(error!.localizedDescription)
                return
                
            }
            
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    self.deleteHistory(docName: document.documentID)
                    
                }
                
            }
            
        }
        
    }
    
    func fetchBookmarks() async
    {
        
        bookmarks.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection(vm.savedUser[0].id! + "-BOOKMARKS")
        
        ref.getDocuments { snapshot, error in
            
            guard error == nil else
            {
                
                print(error!.localizedDescription)
                return
                
            }
            
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    let data = document.data()
                        
                    let id = data["id"] as? String ?? ""
                    let url = data["url"] as? String ?? ""
                    let docName = data["docName"] as? String ?? ""
                        
                    let mark = Bookmarks(id: id, url: url, docName: docName)
                    self.bookmarks.append(mark)
                    
                }
                
                self.bookmarks = self.bookmarks.sorted(by: { $0.docName > $1.docName })
                
            }
            
        }
        
    }
    
    func addBookmark(markUrl: String)
    {
        
        if(vm.savedUser[0].id != nil)
        {
            
            let db = Firestore.firestore()
            
            db.collection(vm.savedUser[0].id! + "-BOOKMARKS").getDocuments()
            {
                (querySnapshot, err) in

                if let err = err
                {
                    print("Error getting documents: \(err)");
                }
                else
                {
                    var count = 0
                    for document in querySnapshot!.documents {
                        count += 1
                        print("\(document.documentID) => \(document.data())");
                    }
                    
                    let ref = db.collection(self.vm.savedUser[0].id! + "-BOOKMARKS").document("\(count)")
                    
                    let docName = ref.documentID
                    
                    let randomID = Int.random(in: 1...1000000)
                    
                    let stringID = "\(randomID)"
                    
                    ref.setData(["url": markUrl, "id": stringID, "docName": docName]) { error in
                        
                        if let error = error {
                            
                            print(error.localizedDescription)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deleteBookmark(docName: String)
    {
        
        let db = Firestore.firestore()
        
        let _: Void = db.collection(vm.savedUser[0].id! + "-BOOKMARKS").document(docName).delete() { error in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            }
            
            
        }
        
    }
    
    func deleteAllBookmarks()
    {
        
        let db = Firestore.firestore()
        let ref = db.collection(vm.savedUser[0].id! + "-BOOKMARKS")
        
        ref.getDocuments { snapshot, error in
            
            guard error == nil else
            {
                
                print(error!.localizedDescription)
                return
                
            }
            
            if let snapshot = snapshot {
                
                for document in snapshot.documents {
                    
                    self.deleteBookmark(docName: document.documentID)
                    
                }
                
            }
            
        }
        
    }
    
}
