//
//  SecondaryView.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 1/21/23.
//

import SwiftUI

struct SecondaryView: View {
    var body: some View {
        Text(Constants.Strings.selectRecipe)
    }
}

struct SecondaryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Device.all, id: \.self) { device in
            SecondaryView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
