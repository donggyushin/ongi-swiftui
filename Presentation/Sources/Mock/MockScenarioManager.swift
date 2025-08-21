//
//  MockScenarioManager.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import Foundation
import Domain

public enum MockScenario: String, CaseIterable {
    case happy = "happy_path"
    case empty = "empty_state"
    case error = "error_prone"
    case newUser = "new_user"
    case popular = "popular_user"
    case slow = "slow_network"
    
    public var displayName: String {
        switch self {
        case .happy: return "행복한 경로"
        case .empty: return "빈 상태"
        case .error: return "오류 발생"
        case .newUser: return "신규 사용자"
        case .popular: return "인기 사용자"
        case .slow: return "느린 네트워크"
        }
    }
    
    public var description: String {
        switch self {
        case .happy: return "모든 기능이 정상적으로 작동하는 상태"
        case .empty: return "데이터가 없는 빈 상태"
        case .error: return "네트워크 오류가 자주 발생하는 상태"
        case .newUser: return "새로 가입한 사용자 상태"
        case .popular: return "많은 좋아요를 받는 인기 사용자 상태"
        case .slow: return "네트워크가 느린 상태"
        }
    }
}

public class MockScenarioManager: ObservableObject {
    @Published public var currentScenario: MockScenario = .happy
    
    public static let shared = MockScenarioManager()
    
    private init() {}
    
    public func setScenario(_ scenario: MockScenario) {
        currentScenario = scenario
        configureRepositories()
    }
    
    private func configureRepositories() {
        // Configure profile repository based on scenario
        configureProfileRepository()
        
        // Configure connection repository based on scenario
        configureConnectionRepository()
    }
    
    private func configureProfileRepository() {
        // This would typically configure the mock profile repository
        // For now, we'll use the scenario in the repositories directly
    }
    
    private func configureConnectionRepository() {
        // This would typically configure the mock connection repository
        // For now, we'll use the scenario in the repositories directly
    }
    
    // MARK: - Scenario Configurations
    public func getScenarioConfig() -> ScenarioConfig {
        switch currentScenario {
        case .happy:
            return ScenarioConfig(
                networkDelay: 500...1000,
                errorRate: 0.0,
                profileCount: 5...8,
                likeMeCount: 3...7,
                newProfileRate: 0.3
            )
            
        case .empty:
            return ScenarioConfig(
                networkDelay: 500...1000,
                errorRate: 0.0,
                profileCount: 0...0,
                likeMeCount: 0...0,
                newProfileRate: 0.0
            )
            
        case .error:
            return ScenarioConfig(
                networkDelay: 1000...3000,
                errorRate: 0.3,
                profileCount: 2...5,
                likeMeCount: 1...3,
                newProfileRate: 0.2
            )
            
        case .newUser:
            return ScenarioConfig(
                networkDelay: 500...1000,
                errorRate: 0.05,
                profileCount: 1...3,
                likeMeCount: 0...1,
                newProfileRate: 0.8
            )
            
        case .popular:
            return ScenarioConfig(
                networkDelay: 300...800,
                errorRate: 0.02,
                profileCount: 8...12,
                likeMeCount: 10...20,
                newProfileRate: 0.4
            )
            
        case .slow:
            return ScenarioConfig(
                networkDelay: 3000...8000,
                errorRate: 0.1,
                profileCount: 3...6,
                likeMeCount: 2...5,
                newProfileRate: 0.3
            )
        }
    }
}

public struct ScenarioConfig {
    public let networkDelay: ClosedRange<Int> // milliseconds
    public let errorRate: Double // 0.0 to 1.0
    public let profileCount: ClosedRange<Int>
    public let likeMeCount: ClosedRange<Int>
    public let newProfileRate: Double // 0.0 to 1.0
    
    public init(
        networkDelay: ClosedRange<Int>,
        errorRate: Double,
        profileCount: ClosedRange<Int>,
        likeMeCount: ClosedRange<Int>,
        newProfileRate: Double
    ) {
        self.networkDelay = networkDelay
        self.errorRate = errorRate
        self.profileCount = profileCount
        self.likeMeCount = likeMeCount
        self.newProfileRate = newProfileRate
    }
}

// MARK: - Scenario Testing Extensions
extension MockScenarioManager {
    
    public func runScenarioTest(_ scenario: MockScenario, completion: @escaping (ScenarioTestResult) -> Void) {
        setScenario(scenario)
        
        Task {
            var results = ScenarioTestResult()
            
            // Test profile loading
            do {
                let start = Date()
                // Simulate profile repository call
                try await Task.sleep(for: .milliseconds(Int.random(in: getScenarioConfig().networkDelay)))
                results.profileLoadTime = Date().timeIntervalSince(start)
                results.profileLoadSuccess = true
            } catch {
                results.profileLoadSuccess = false
                results.errors.append(error.localizedDescription)
            }
            
            // Test connection loading
            do {
                let start = Date()
                try await Task.sleep(for: .milliseconds(Int.random(in: getScenarioConfig().networkDelay)))
                results.connectionLoadTime = Date().timeIntervalSince(start)
                results.connectionLoadSuccess = true
            } catch {
                results.connectionLoadSuccess = false
                results.errors.append(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    public func resetToDefault() {
        setScenario(.happy)
    }
}

public struct ScenarioTestResult {
    public var profileLoadTime: TimeInterval = 0
    public var connectionLoadTime: TimeInterval = 0
    public var profileLoadSuccess: Bool = false
    public var connectionLoadSuccess: Bool = false
    public var errors: [String] = []
    
    public var overallSuccess: Bool {
        return profileLoadSuccess && connectionLoadSuccess
    }
    
    public var averageLoadTime: TimeInterval {
        return (profileLoadTime + connectionLoadTime) / 2
    }
}

// MARK: - Debug Helpers
#if DEBUG
extension MockScenarioManager {
    
    public func debugInfo() -> String {
        let config = getScenarioConfig()
        return """
        현재 시나리오: \(currentScenario.displayName)
        설명: \(currentScenario.description)
        
        구성:
        - 네트워크 지연: \(config.networkDelay.lowerBound)-\(config.networkDelay.upperBound)ms
        - 오류율: \(Int(config.errorRate * 100))%
        - 프로필 수: \(config.profileCount.lowerBound)-\(config.profileCount.upperBound)개
        - 좋아요 수: \(config.likeMeCount.lowerBound)-\(config.likeMeCount.upperBound)개
        - 신규 프로필 비율: \(Int(config.newProfileRate * 100))%
        """
    }
    
    public func createTestData() -> [String: Any] {
        let config = getScenarioConfig()
        
        return [
            "scenario": currentScenario.rawValue,
            "config": [
                "networkDelay": "\(config.networkDelay.lowerBound)-\(config.networkDelay.upperBound)",
                "errorRate": config.errorRate,
                "profileCount": "\(config.profileCount.lowerBound)-\(config.profileCount.upperBound)",
                "likeMeCount": "\(config.likeMeCount.lowerBound)-\(config.likeMeCount.upperBound)",
                "newProfileRate": config.newProfileRate
            ]
        ]
    }
}
#endif