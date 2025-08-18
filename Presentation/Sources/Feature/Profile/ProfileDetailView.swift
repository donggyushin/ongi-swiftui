//
//  ProfileDetailView.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import SwiftUI

struct ProfileDetailView: View {
    
    @StateObject var model: ProfileDetailViewModel
    
    var body: some View {
        Text(model.profileId)
    }
}
