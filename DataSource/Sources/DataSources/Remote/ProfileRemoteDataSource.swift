//
//  ProfileRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Foundation

final class ProfileRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        struct DTO: Decodable {
            let profile: ProfileResponseDTO
        }
        
        let response: APIResponse<DTO> = try await networkManager.request(url: "\(ongiExpressUrl)accounts/me")
        if let profile = response.data?.profile.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        let response: APIResponse<ProfileResponseDTO> = try await networkManager.upload(url: "\(ongiExpressUrl)profiles/me/upload-image") { form in
            form.append(imageData, withName: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg")
        }
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
