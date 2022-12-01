//
//  ContentView.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI
import Firebase
import GoogleSignInSwift
import GoogleSignIn

struct MenuItem: Identifiable
{
    
    var id = UUID()
    let text: String
    let icon: String
    let viewType: Int
    
}

struct MenuContent: View
{
    
    let items: [MenuItem] = [
        MenuItem(text: "Google Account", icon: "person.circle", viewType: 0),
        MenuItem(text: "View The Weather", icon: "cloud.sun", viewType: 1)
    
    ]
    
    var body: some View
    {
        
        NavigationView
        {
            
            ZStack
            {
                
                Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30)
                {
                    
                    ForEach(items) { item in
                        
                        NavigationLink(destination: chooseDestination(i: item.viewType), label:
                        {
                            
                            HStack
                            {
                                
                                Image(systemName: item.icon)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8)
                                Text(item.text)
                                    .foregroundColor(.white)
                                    .font(.body)
                                
                            }
                            
                        })
                        
                    }
                    
                }
                .offset(y: -250)
                
            }
            
        }
        
    }
    
    @ViewBuilder
    func chooseDestination(i: Int) -> some View {
        
        switch i {
            case 0: SignInView()
            case 1: WeatherView()
            default: EmptyView()
            }
        
        
    }
    
}

struct SideMenu: View
{
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    var body: some View
    {
        
        ZStack
        {
            
            GeometryReader{ _ in
                
                EmptyView()
                
            }
            .background(Color.white.opacity(0.15))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                
                self.toggleMenu()
                
            }
            
            HStack
            {
                
                MenuContent()
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default)
                
                Spacer()
                
            }
            
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
}

struct BrowserView: View
{
    
    @State public var urlSearch = ""
    @State public var isActive = false
    @StateObject var searchVM = NewSearchViewModel()
    @StateObject var dataManager = DataManager()
    @State var menuOpened = false
    @StateObject var vm =  CoreDataViewModel()
    
    var body: some View
    {
        
        ZStack
        {
            
            NavigationView
            {
                    
                VStack
                {
                    
                    Spacer()
                    
                    Text("Search Bar")
                        .font(.system(size: 25))
                    HStack
                    {
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("", text: $urlSearch)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(maxWidth: .infinity)
                            .submitLabel(.go)
                            .onSubmit {
                                
                                searchVM.setSearch(search: urlSearch)
                                isActive = true
                               
                                dataManager.addHistory(histUrl: urlSearch)
                                    
                                
                            }
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.white, lineWidth: 2)
                            )
                        
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: NewSearchView(), isActive: $isActive) { }
                    
                }
                .padding()
                .navigationTitle("Browse The Web")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        
                        Button
                        {
                            
                            self.menuOpened.toggle()
                            
                        } label:
                        {
                            
                            VStack
                            {
                                
                                Image(systemName: "ellipsis.circle")
                                Text("More")
                                    .font(.system(size: 12))
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                .background(Color(red: 50/255, green: 50/255, blue: 50/255))
                
            }
            .environmentObject(searchVM)
            .onAppear
            {
                
                let randomID = Int.random(in: 1...1000000)
                
                let stringID = "\(randomID)"
                
                if(vm.savedUser.count == 0)
                {
                    vm.addUser(text: stringID)
                    print(stringID)
                }
                
            }
            
            SideMenu(width: UIScreen.main.bounds.width/1.6, menuOpened: menuOpened, toggleMenu: toggleMenu)
            
        }
        
    }
    
    func toggleMenu()
    {
        
        menuOpened.toggle()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
