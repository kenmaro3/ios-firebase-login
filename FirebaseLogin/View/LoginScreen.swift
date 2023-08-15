//
//  LoginScreen.swift
//  FirebaseLogin
//
//  Created by Kentaro Mihara on 2023/08/08.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase

import AuthenticationServices


struct LoginScreen: View {
    @StateObject var loginModel: LoginViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment: .leading){
               Image("logo_black")
                    .resizable()
                    .frame(width: 96, height: 64)
                    
                    //.font(.system(size: 38))
                    .foregroundColor(.indigo)
                    .padding(.top, 20)
                
                (Text("Welcome\n")
                    .foregroundColor(.black) +
                 Text("to App")
                    .foregroundColor(.gray)
                )
                .font(.title)
                .fontWeight(.semibold)
                .lineSpacing(10)
                .padding(.top, 20)
                .padding(.trailing, 15)
                
                
                VStack(
                    alignment: .leading
                ){
                    // MARK: Custom Apple Sign in Button
                    Text("Sign in with Apple")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineSpacing(10)
                        .padding(.top, 20)
                        .padding(.trailing, 15)
                    
                    CustomButton(isGoogle: false)
                        .overlay{
                            SignInWithAppleButton{ (request) in
                                
                                // requesting parameters from apple login...
                                loginModel.nonce = randomNonceString()
                                request.requestedScopes = [.email, .fullName]
                            } onCompletion: {(result) in
                                
                                //getting error or success..
                                switch result{
                                case .success(let user):
                                    print("success")
                                    //do login with firebase...
                                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                                        print("error with firebase")
                                        return
                                    }
                                    loginModel.appleAuthenticate(credential: credential)
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }

                            }
                            .signInWithAppleButtonStyle(.white)
                            .frame(height: 55)
                            .blendMode(.overlay)
                        }
                        .clipped()
                    
                    
                    
                    
                    Text("(OR)")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                    
                    
                    Text(String(localized: "Sign in with Google"))
                        .foregroundColor(.gray)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineSpacing(10)
                        .padding(.top, 20)
                        .padding(.trailing, 15)
                    // MARK: Custom Google Sign in Button
                    CustomButton(isGoogle: true)
                        .overlay{
                            // MARK: We Have Native Google Sign In Button
                            if let clientID = FirebaseApp.app()?.options.clientID{
                                
                                GoogleSignInButton{
                                    //GIDSignIn.sharedInstance.signIn(with: .init(clientID: clientID), presenting: UIApplication.shared.rootController()){user, error in
                                    GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController()){ res, error in
                                        
                                    //GIDSignIn.sharedInstance.signIn(with: .init(), presenting: UIApplication.shared.rootController()){user, error in
                                        if let error = error{
                                            print(error.localizedDescription)
                                            return
                                        }
                                        
                                        // MARK: Logging Google User into Firebase
                                        if let user = res?.user{
                                            loginModel.logGoogleUser(user: user)
                                        }

                                    }
                                }
                                .blendMode(.overlay)
                            }
                            
                        }
                        .clipped()
                    
                }
                .padding(.top, 40)
                
                
            }
            .padding(.leading, 40)
            .padding(.top, 60)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .alert(loginModel.successMessage, isPresented: $loginModel.showSuccess){
            
        }
        .alert(loginModel.errorMessage, isPresented: $loginModel.showError){
            
        }
    }
    
    @ViewBuilder
    func CustomButton(isGoogle: Bool)->some View{
        HStack{
            Group{
                if isGoogle{
                    Image("google_logo")
                        .resizable()
                        .renderingMode(.template)

                }else{
                    Image(systemName: "applelogo")
                        .resizable()
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .frame(height: 45)
            Text("\(isGoogle ? "Google" : "Apple") Signin")
                .font(.callout)
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 15)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.black)
        }
        
    }
}

