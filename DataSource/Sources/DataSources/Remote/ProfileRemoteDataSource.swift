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
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .upload(url: "\(ongiExpressUrl)profiles/me/upload-image") { form in
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
    
    func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .upload(url: "\(ongiExpressUrl)profiles/me/add-image") { form in
                form.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy {
        
        let body: [String: Any] = [
            "gender" : gender == .male ? "MALE" : "FEMALE"
        ]
        
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .request(url: "\(ongiExpressUrl)profiles/me/gender", method: .post, parameters: body)
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy {
        let body: [String: Any] = [
            "height": height,
            "weight": weight
        ]
        
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .request(url: "\(ongiExpressUrl)profiles/me/physical-info", method: .post, parameters: body)
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func deleteImage(publicId: String) async throws -> ProfileEntitiy {
        
        let parameters: [String: Any] = [
            "publicId": publicId
        ]
        
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .request(
                url: "\(ongiExpressUrl)profiles/me/images",
                method: .delete,
                parameters: parameters
            )
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func updateNickname(nickname: String) async throws -> ProfileEntitiy {
        let parameters: [String: Any] = [
            "nickname": nickname
        ]
        
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .request(
                url: "\(ongiExpressUrl)profiles/nickname",
                method: .patch,
                parameters: parameters
            )
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    private func mbtiToString(_ mbti: MBTIEntity) -> String {
        switch mbti {
        case .intj: return "INTJ"
        case .intp: return "INTP"
        case .entj: return "ENTJ"
        case .entp: return "ENTP"
        case .infj: return "INFJ"
        case .infp: return "INFP"
        case .enfj: return "ENFJ"
        case .enfp: return "ENFP"
        case .istj: return "ISTJ"
        case .isfj: return "ISFJ"
        case .estj: return "ESTJ"
        case .esfj: return "ESFJ"
        case .istp: return "ISTP"
        case .isfp: return "ISFP"
        case .estp: return "ESTP"
        case .esfp: return "ESFP"
        }
    }
    
    func updateMBTI(mbti: MBTIEntity) async throws -> ProfileEntitiy {
        let parameters: [String: Any] = [
            "mbti": mbtiToString(mbti)
        ]
        
        let response: APIResponse<ProfileResponseDTO> = try await networkManager
            .request(
                url: "\(ongiExpressUrl)profiles/me/mbti",
                method: .post,
                parameters: parameters
            )
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
