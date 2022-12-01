//
//  HistoryView.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI

struct HistoryView: View
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
                    
                    ForEach(dataManager.history, id: \.id) { hist in
                        
                        Text(hist.url)
                            .listRowBackground(Color(red: 50/255, green: 50/255, blue: 50/255))
                        
                        
                    }
                    .onDelete(perform: deleteHis)
                    
                }
                .navigationTitle("History")
                .task
                {
                    
                    await dataManager.fetchHistory()
                                    
                    
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
                                    title: Text("Are You Sure You Want To Delete All History?"),
                                    primaryButton: .destructive(Text("Delete"))
                                    {
                                        
                                        dataManager.history.removeAll()
                                        dataManager.deleteAllHistory()
                                        
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                    
                }

                
            }
            
        }
    
    }
    
    private func deleteHis(at offsets: IndexSet)
    {
        
        offsets.forEach { index in
            
            let hist = dataManager.history[index]
        
            dataManager.deleteHistory(docName: hist.docName)
            
        }
        
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
