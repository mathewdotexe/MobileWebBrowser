//
//  Address.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/28/22.
//

import SwiftUI

struct AddressData : Hashable, Codable
{
    
    let adminCode2: String?
    let adminCode3: String?
    let adminCode1: String?
    let lng: String?
    let distance: String?
    let houseNumber: String?
    let locality: String?
    let adminCode4: String?
    let adminName2: String?
    let street: String?
    let postalCode: String?
    let countryCode: String?
    let adminName1: String?
    let lat: String?
    
}

struct AddressRoot: Decodable
{
    
    let address: AddressData
    
}

