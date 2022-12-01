//
//  BookmarksView.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI

struct BookmarksView: View
{
    
    @StateObject var dataManager = DataManager()
    @State private var showingAlert = false
    
    var body: some View
    {
        
        NavigationView
        {
                
            ZStack
            {
                
                Color(red: 50/255, green: 50/255, blue: 50/255)
                    .ignoresSafeArea()
            
                List
                {
                    
                    ForEach(dataManager.bookmarks, id: \.id) { hist in
                        
                        Text(hist.url)
                            .listRowBackground(Color(red: 50/255, green: 50/255, blue: 50/255))
                        
                        
                    }
                    .onDelete(perform: deleteMark)
                    
                }
                .navigationTitle("Bookmarks")
                .task
                {
                    
                    await dataManager.fetchBookmarks()
                    
                }
                
            
            }
            .toolbar
            {
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    
                    Button
                    {
                        
                        showingAlert = true
                        
                    } label : {
                        
                        VStack
                        {
                            
                            Image(systemName: "minus.circle")
                            Text("Delete All")
                                .font(.system(size: 12))
                            
                        }
                        
                    }
                    .alert(isPresented:$showingAlert) {
                                Alert(
                                    title: Text("Are You Sure You Want To Delete All Bookmarks?"),
                                    primaryButton: .destructive(Text("Delete"))
                                    {
                                        
                                        dataManager.bookmarks.removeAll()
                                        dataManager.deleteAllBookmarks()
                                        
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                    
                }

                
            }
            
        }
    
    }
    
    private func deleteMark(at offsets: IndexSet)
    {
        
        offsets.forEach { index in
            
            let mark = dataManager.bookmarks[index]
        
            dataManager.deleteBookmark(docName: mark.docName)
            
        }
        
    }
    
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
