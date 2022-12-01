//
//  NewSearchViewModel.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI

class NewSearchViewModel: ObservableObject
{
    
    @Published var newSearch = ""
    
    func setSearch(search: String)
    {
        
        if(search.contains("https://www."))
        {
            
            newSearch = search
            
        }
        else if(search.contains("www.") && !search.contains("https://"))
        {
            
            newSearch = "https://" + search
            
        }
        else
        {
            
            newSearch = "https://www." + search
            
        }
        
    }
    
}
