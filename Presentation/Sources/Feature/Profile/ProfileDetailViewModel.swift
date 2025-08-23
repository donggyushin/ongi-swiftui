//
//  ProfileDetailViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import Factory
import Domain
import SwiftUI
import Combine

public final class ProfileDetailViewModel: ObservableObject {
    
    public let profileId: String
    
    @Published var me: ProfileEntitiy?
    @Published var isMe = false
    @Published var isLikedByMe = false
    
    @Published var photoURLOfTheMainGate: URL?
    @Published var profilePhotoURL: URL?
    @Published var nickname = ""
    @Published var isVerified = false
    @Published var mbti: MBTIEntity?
    @Published var gender: GenderEntity?
    @Published var height: CGFloat?
    @Published var weight: CGFloat?
    @Published var bodyType: BodyType?
    
    @Published var introduction: String?
    
    @Published var photoURLs: [URL] = []
    @Published var qnas: [QnAEntity] = []
    @Published var lastTokenAuthAt: Date?
    @Published var location: LocationEntity?
    
    @Published var loading = false
    
    var lastLoginDaysAgo: Int {
        guard let lastTokenAuthAt = lastTokenAuthAt else { return 0 }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: lastTokenAuthAt, to: now)
        return components.day ?? 0
    }
    
    @Injected(\.profileUseCase) private var profileUseCase
    @Injected(\.connectionUseCase) private var connectionUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    public init(profileId: String) {
        self.profileId = profileId
        
        bind()
    }
    
    @MainActor
    func fetchProfile() async throws {
        loading = true
        defer { loading = false }
        var profile = try await profileUseCase.search(profileId: profileId)
        
        if profile.images.isEmpty == false {
            withAnimation {
                photoURLOfTheMainGate = profile.images.removeFirst().url
            }
        }
        
        profilePhotoURL = profile.profileImage?.url
        nickname = profile.nickname
        isVerified = profile.email != nil
        mbti = profile.mbti
        gender = profile.gender
        height = profile.height
        weight = profile.weight
        bodyType = profile.bodyType
        introduction = profile.introduction
        isLikedByMe = profile.isLikedByMe
        photoURLs = profile.images.map { $0.url }
        qnas = profile.qnas
        lastTokenAuthAt = profile.lastTokenAuthAt
        location = profile.location
    }
    
    @MainActor
    func like() async throws {
        loading = true
        defer { loading = false }
        try await connectionUseCase.like(profileId: profileId, currentValue: isLikedByMe)
        isLikedByMe.toggle()
    }
    
    private func bind() {
        contentViewModel
            .$me
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
        
        let profileId = profileId
        $me
            .map { $0?.id }
            .map { $0 == profileId }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$isMe)
    }
}
