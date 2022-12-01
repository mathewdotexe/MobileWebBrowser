//
//  AddressViewModel.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/28/22.
//

import SwiftUI

class AddressViewModel: ObservableObject
{
    
    @Published var addressData = AddressData(adminCode2: "", adminCode3: "", adminCode1: "", lng: "", distance: "", houseNumber: "", locality: "", adminCode4: "", adminName2: "", street: "", postalCode: "", countryCode: "", adminName1: "", lat: "")
    
    func fetch(lat: Double, lon: Double, username: String)
    {
        
        let theUrl = "http://api.geonames.org/addressJSON?" + "&lat=" + "\(lat)" + "&lng=" + "\(lon)" + "&username=" + username
                
        guard let url = URL(string: theUrl) else
        {
            
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else
            {
                
            
                return
                
            }
            
            print("--> data: \(String(data: data, encoding: .utf8))")
            
            do
            {
                
                let answerCreateResponse = try JSONDecoder().decode(AddressRoot.self, from: data).address
                
                DispatchQueue.main.async {
                    self?.addressData = answerCreateResponse
                }
                
            }
            catch
            {
                
                print(error)
                
            }
            
        }
        
        task.resume()
        
    }
    
}
