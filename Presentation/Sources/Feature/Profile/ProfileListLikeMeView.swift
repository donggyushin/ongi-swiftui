//
//  ProfileListLikeMeView.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI
import Domain

struct ProfileListLikeMeView: View {
    
    @StateObject var model: ProfileListLikeMeViewModel
    
    var body: some View {
        Text("ProfileListLikeMeView")
    }
}

#Preview {
    ProfileListLikeMeView(model: .init())
}
