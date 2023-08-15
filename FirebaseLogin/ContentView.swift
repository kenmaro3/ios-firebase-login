//
//  ContentView.swift
//  FirebaseLogin
//
//  Created by Kentaro Mihara on 2023/08/08.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        if(logStatus){
            Home()
            
        }else{
            LoginScreen()
        }
    }
}

#Preview {
    ContentView()
}
