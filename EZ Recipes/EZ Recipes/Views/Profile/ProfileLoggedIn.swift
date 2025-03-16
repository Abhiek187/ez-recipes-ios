//
//  ProfileLoggedIn.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 3/16/25.
//

import SwiftUI

struct ProfileLoggedIn: View {
    var body: some View {
        VStack {
            Text(Constants.ProfileView.profileHeader("test@example.com"))
                .font(.title)
            
            HStack {
                Text(Constants.ProfileView.favorites(1))
                Divider()
                Text(Constants.ProfileView.recipesViewed(2))
                Divider()
                Text(Constants.RecipeView.totalRatings(3))
            }
            .fixedSize() // prevent the dividers from taking up the full height
            
            List {
                Button {
                    print("Logout")
                } label: {
                    Text(Constants.ProfileView.logout)
                        .font(.title3)
                }
                .clipShape(Capsule())
                Button {
                    print("Change Email")
                } label: {
                    Text(Constants.ProfileView.changeEmail)
                        .font(.title3)
                }
                Button {
                    print("Change Password")
                } label: {
                    Text(Constants.ProfileView.changePassword)
                        .font(.title3)
                }
                Button {
                    print("Delete Account")
                } label: {
                    Text(Constants.ProfileView.deleteAccount)
                        .font(.title3)
                        .tint(.red)
                }
            }
        }
    }
}

#Preview {
    ProfileLoggedIn()
}
