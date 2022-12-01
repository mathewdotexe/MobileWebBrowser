//
//  NewSearchView.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/26/22.
//

import SwiftUI

struct NewSearchView: View
{
    
    @State var theSearch = ""
    @EnvironmentObject var searchVM: NewSearchViewModel
    @StateObject var dataManager = DataManager()
    @State var title: String = ""
    @State var error: Error? = nil
    @State private var showningFloatingView = false
    @State private var showningErrorView = false

    
    var body: some View
    {
        
        NavigationView
        {
            
            ZStack
            {
                
                Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
                    .ignoresSafeArea()
                
                WebView(title: $title, url: URL(string: searchVM.newSearch)!)
                    .onLoadStatusChanged {
                        
                        loading, error in
                        if loading {
                            
                            print("Loading started")
                            self.title = "Loading..."
                            
                        }
                        else {
                            
                            print("Done loading.")
                            
                            if let error = error {
                                
                                self.error = error
                                
                                if self.title.isEmpty {
                                    
                                    self.title = "Error"
                                    
                                }
                                
                            }
                            else if self.title.isEmpty {
                                
                                self.title = "Some Place"
                                
                            }
                            
                        }
                        
                    }
                
                if showningFloatingView {
                    
                    FloatingNoticeView()
                        .onAppear {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                
                                self.showningFloatingView.toggle()
                                
                            }
                            
                        }
                        .animation(.easeInOut)
                }
                else if showningErrorView {
                    
                    ErrorNoticeView()
                        .onAppear {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                
                                self.showningErrorView.toggle()
                                
                            }
                            
                        }
                        .animation(.easeInOut)
                }
                
            }
            
        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing)
            {
                
                Button
                {
                    
                    if(title != "Loading..." && title != "")
                    {
                        
                        dataManager.addBookmark(markUrl: title)
                        self.showningFloatingView.toggle()
                        
                    }
                    else
                    {
                        
                        self.showningErrorView.toggle()
                        
                    }
                    
                } label : {
                    
                    
                    VStack
                    {
                        
                        Image(systemName: "book")
                        Text("Bookmark This")
                            .font(.system(size: 12))
                        Spacer()
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}

struct FloatingNoticeView: View {
    var body: some View {
        ZStack {

            BlurView()

            VStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 80))
                Text("Bookmarked")
                    .padding(.top, 8)
                    .font(.system(size: 20))
            }
            .foregroundColor(.primary)
        }
        .frame(width: 200, height: 200)
        .cornerRadius(10)
    }
}

struct ErrorNoticeView: View {
    var body: some View {
        ZStack {

            BlurView()

            VStack {
                Image(systemName: "x.circle")
                    .font(.system(size: 80))
                Text("Page Loading")
                    .padding(.top, 8)
                    .font(.system(size: 20))
            }
            .foregroundColor(.red)
        }
        .frame(width: 200, height: 200)
        .cornerRadius(10)
    }
}


struct BlurView: UIViewRepresentable {

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) {

    }
}

struct NewSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NewSearchView()
    }
}
