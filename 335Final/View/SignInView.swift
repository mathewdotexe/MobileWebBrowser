import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift
import UIKit

struct SignInView: View {
    //Loading indicator
    
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var log_Status = false
    
    @AppStorage("userEmail") var emailAddress:String?
    @AppStorage("displayName") var displayName:String?
    @AppStorage("profilePicUrl") var profilePicUrl:URL?
    
    var body: some View
    {
        
        if log_Status
        {
            
            NavigationView
            {
                
                ZStack
                {
                    
                    VStack(spacing: 30)
                    {
                        
                        Spacer()
                        Text("Logged In")
                            .font(.system(size: 30))
                        
                        Text("email:")
                        Text("\(emailAddress ?? "none" )")
                        Text("display name:")
                        Text("\(displayName ?? "none")")
                        AsyncImage(url: profilePicUrl)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        
                        
                        Button
                        {
                            
                            GIDSignIn.sharedInstance.signOut()
                            try? Auth.auth().signOut()
                            
                            withAnimation {
                                log_Status = false
                            }
                        } label:
                        {
                            
                            Text("Sign Out")
                                .foregroundColor(.black)
                            
                        }
                        .background(
                            Capsule()
                                .foregroundColor(.white)
                                .frame(width: 100, height: 30)
                            
                            )
                        
                        Spacer()
                        
                    }
                }
                .offset(x: -5)
                .offset(y: -40)
                
            }
        }
        else
        {
            
            ZStack
            {
                
                Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
                    .ignoresSafeArea()
                
                VStack(spacing: 50)
                {
                    
                    Spacer()
                    
                    Text("Sign In With Google!")
                        .font(.system(size: 20))
                    
                    Button
                    {
                        
                        handleLogin()
                        
                    } label:
                    {
                        
                        HStack(spacing: 20)
                        {
                            
                            Image("google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                            
                            
                            Text("Sign In")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                            
                        }
                        .background(
                            Capsule()
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                            
                        )
                    }
                    
                    Spacer()
                    
                }
                .offset(y: -100)
                .overlay(
                    ZStack
                    {
                        
                        if isLoading
                        {
                            
                            Color.black
                                .opacity(0.25)
                                .ignoresSafeArea()
                            
                            ProgressView()
                                .font(.title2)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                        }
                    }
                )
                
            }
            .offset(x: -5)
            
        }
        
    }
    
    func handleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, err in
            
            if let error = err {
                isLoading = false
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // Firebase Auth
            Auth.auth().signIn(with: credential) { result, err in
                isLoading = false
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    return
                }
                print(user.displayName ?? "Success!")
                emailAddress = user.email ?? ""
                displayName = user.displayName ?? ""
                profilePicUrl = user.photoURL
                
                
                withAnimation {
                    log_Status = true
                }
            }
            
        }
    }
}



struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
    
    //retreiving RootView Controller
    func getRootViewController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
