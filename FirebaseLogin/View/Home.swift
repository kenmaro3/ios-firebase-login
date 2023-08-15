//
//  Home.swift
//  FirebaseLogin
//
//  Created by Kentaro Mihara on 2023/08/09.
//

import SwiftUI

struct Home: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                logStatus = false
                
            }, label:{
                Text("Log out")
            })
        }
    }
}

#Preview {
    Home()
}
