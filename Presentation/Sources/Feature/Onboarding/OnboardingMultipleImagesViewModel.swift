//
//  OnboardingMultipleImagesViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Factory
import Combine
import SwiftUI
import Kingfisher

final class OnboardingMultipleImagesViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    @Published var fetchingInitialData = true
    @Published var loading = false 
    
    let profileUseCase: ProfileUseCase
    
    init() {
        profileUseCase = Container.shared.profileUseCase()
    }
    
    @MainActor
    func addPhoto() async throws {
//        loading = true
//        try await profileUseCase.uploadImage(imageData: <#T##Data#>)
//        loading = false
    }
    
    @MainActor
    func fetchInitialImages() async throws {
        let myProfile = try await profileUseCase.getMe()
        
        if myProfile.images.isEmpty {
            images = []
            withAnimation {
                fetchingInitialData = false
            }
            return
        }
        
        // 병렬로 이미지 다운로드하되 순서는 유지
        let imageResults = await withTaskGroup(of: (Int, UIImage?).self) { group in
            // 각 이미지를 병렬로 다운로드
            for (index, imageData) in myProfile.images.enumerated() {
                group.addTask {
                    await self.downloadImage(from: imageData.url, index: index)
                }
            }
            
            var results: [(Int, UIImage?)] = []
            for await result in group {
                results.append(result)
            }
            return results
        }
        
        // 인덱스 순서대로 정렬하여 UIImage 배열 생성
        let sortedResults = imageResults.sorted { $0.0 < $1.0 }
        let downloadedImages = sortedResults.compactMap { $0.1 }
        
        images = downloadedImages
        
        try await Task.sleep(for: .seconds(0.5))
        
        withAnimation {
            fetchingInitialData = false
        }
    }
    
    private func downloadImage(from url: URL, index: Int) async -> (Int, UIImage?) {
        return await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    continuation.resume(returning: (index, imageResult.image))
                case .failure:
                    continuation.resume(returning: (index, nil))
                }
            }
        }
    }
}
