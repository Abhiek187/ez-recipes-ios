//
//  ProfileLoggedOut.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI

struct ProfileLoggedOut: View {
    var body: some View {
        VStack {
            Text(Constants.ProfileView.loginMessage)
            
            Button {
                print("Open login modal")
            } label: {
                Text(Constants.ProfileView.login)
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
