//
//  ProfileLoggedOut.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI

struct ProfileLoggedOut: View {
    @State private var showLoginSheet = false
    
    var body: some View {
        VStack {
            Text(Constants.ProfileView.loginMessage)
            
            Button {
                showLoginSheet.toggle()
            } label: {
                Text(Constants.ProfileView.login)
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginSheet()
            }
            
            Spacer()
        }
        .padding()
        .font(.title2)
    }
}

#Preview {
    ProfileLoggedOut()
}
