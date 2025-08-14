//
//  ProfileListView.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import SwiftUI
import Domain
import Factory

public struct ProfileListView: View {
    
    @StateObject var model: ProfileListViewModel
    
    public init(model: ProfileListViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        Text("여기에 유저들의 프로필 리스트가 보일거임")
    }
}
