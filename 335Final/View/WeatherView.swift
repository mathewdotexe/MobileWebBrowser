//
//  WeatherView.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI
import MapKit

struct WeatherView: View
{
    
    @StateObject var mapVM = MapViewModel()
    @StateObject var vm = WeatherViewModel()
    @StateObject var vm2 = AddressViewModel()
    @State var locationManager = CLLocationManager()
    @State var trueLat = 0.0
    @State var trueLon = 0.0
    @State var username = "mathewdotexe"
    @State var theTemp = 0.0
    
    var body: some View
    {
        
        ZStack
        {
            
            Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
                .ignoresSafeArea()
            Text("Weather")
                .font(.system(size: 35))
                .offset(y: -250)
            VStack
            {
            

                Text(vm2.addressData.locality! + " " + vm2.addressData.adminCode1!)
                
                Image(systemName: vm.weatherImage)
                    .font(.system(size: 40))
                    .padding(10)
                Text("\(vm.convertedTemp)")
                    .font(.system(size: 30))
                
                
                
            }
            .offset(y: -125)
            
            VStack
            {
                Map(coordinateRegion: $mapVM.region, showsUserLocation: true)
                    .environmentObject(mapVM)
                    .cornerRadius(10)
                    .frame(width: 200, height: 200)
                    .onAppear {
                        
                        mapVM.checkIfLocationServicesIsEnabled()
                        
                    }
                    .onChange(of: mapVM.flag, perform: { value in
                        
                        trueLat = mapVM.region.center.latitude
                        trueLon = mapVM.region.center.longitude
                        
                        trueLat = Double(round(10000*(trueLat))/10000)
                        trueLon = Double(round(10000*(trueLon))/10000)
                        
                        vm2.fetch(lat: trueLat, lon: trueLon, username: username)
                        vm.fetch(lat: trueLat, lon: trueLon, username: username)
                        
                        
                    })
                
            }
            .offset(y: 150)
            
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
