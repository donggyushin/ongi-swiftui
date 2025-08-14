import Foundation

public enum AppError: Error {
    // Network errors
    case networkError(NetworkError)
    
    // Authentication errors
    case authenticationError(AuthError)
    
    // Validation errors
    case validationError(ValidationError)
    
    // Data errors
    case dataError(DataError)
    
    // System errors
    case systemError(SystemError)
    
    // Custom error with message
    case custom(String, code: Int? = nil)
    
    // Unknown error
    case unknown(Error?)
}

// MARK: - Network Errors
public enum NetworkError {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidResponse
    case decodingFailed
    case encodingFailed
    case invalidURL
}

// MARK: - Authentication Errors
public enum AuthError {
    case unauthorized
    case tokenExpired
    case tokenNotFound
    case refreshTokenExpired
    case invalidCredentials
    case loginRequired
}

// MARK: - Validation Errors
public enum ValidationError {
    case invalidEmail
    case invalidPassword
    case emptyField(String)
    case invalidFormat(String)
    case outOfRange(String)
}

// MARK: - Data Errors
public enum DataError {
    case notFound
    case saveFailure
    case loadFailure
    case corruptedData
    case duplicateEntry
}

// MARK: - System Errors
public enum SystemError {
    case memoryWarning
    case diskFull
    case permissionDenied
    case unavailable
}

// MARK: - LocalizedError
extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .authenticationError(let error):
            return error.localizedDescription
        case .validationError(let error):
            return error.localizedDescription
        case .dataError(let error):
            return error.localizedDescription
        case .systemError(let error):
            return error.localizedDescription
        case .custom(let message, _):
            return message
        case .unknown(let error):
            return error?.localizedDescription ?? "알 수 없는 오류가 발생했습니다"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .networkError(_):
            return "네트워크 관련 오류"
        case .authenticationError(_):
            return "인증 관련 오류"
        case .validationError(_):
            return "입력값 검증 오류"
        case .dataError(_):
            return "데이터 처리 오류"
        case .systemError(_):
            return "시스템 관련 오류"
        case .custom(_, let code):
            return code != nil ? "사용자 정의 오류 (코드: \(code!))" : "사용자 정의 오류"
        case .unknown(_):
            return "알 수 없는 오류"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .networkError(let error):
            return error.recoverySuggestion
        case .authenticationError(let error):
            return error.recoverySuggestion
        case .validationError(let error):
            return error.recoverySuggestion
        case .dataError(let error):
            return error.recoverySuggestion
        case .systemError(let error):
            return error.recoverySuggestion
        case .custom(_, _):
            return "문제가 지속되면 고객센터에 문의해주세요"
        case .unknown(_):
            return "앱을 다시 시작하거나 고객센터에 문의해주세요"
        }
    }
}

// MARK: - Detailed Error Descriptions
extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "인터넷 연결을 확인해주세요"
        case .timeout:
            return "요청 시간이 초과되었습니다"
        case .serverError(let code):
            return "서버 오류가 발생했습니다 (코드: \(code))"
        case .invalidResponse:
            return "서버 응답이 올바르지 않습니다"
        case .decodingFailed:
            return "데이터 파싱에 실패했습니다"
        case .encodingFailed:
            return "데이터 인코딩에 실패했습니다"
        case .invalidURL:
            return "잘못된 URL입니다"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .noConnection:
            return "Wi-Fi 또는 모바일 데이터 연결을 확인하고 다시 시도해주세요"
        case .timeout:
            return "잠시 후 다시 시도해주세요"
        case .serverError(_):
            return "잠시 후 다시 시도하거나 고객센터에 문의해주세요"
        case .invalidResponse, .decodingFailed, .encodingFailed, .invalidURL:
            return "문제가 지속되면 고객센터에 문의해주세요"
        }
    }
}

extension AuthError {
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return "접근 권한이 없습니다"
        case .tokenExpired:
            return "로그인이 만료되었습니다"
        case .tokenNotFound:
            return "인증 정보를 찾을 수 없습니다"
        case .refreshTokenExpired:
            return "재인증이 필요합니다"
        case .invalidCredentials:
            return "아이디 또는 비밀번호가 올바르지 않습니다"
        case .loginRequired:
            return "로그인이 필요합니다"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .unauthorized:
            return "관리자에게 권한 요청을 문의해주세요"
        case .tokenExpired, .tokenNotFound, .refreshTokenExpired, .loginRequired:
            return "다시 로그인해주세요"
        case .invalidCredentials:
            return "아이디와 비밀번호를 확인하고 다시 시도해주세요"
        }
    }
}

extension ValidationError {
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return "올바른 이메일 주소를 입력해주세요"
        case .invalidPassword:
            return "비밀번호 조건을 확인해주세요"
        case .emptyField(let field):
            return "\(field)을(를) 입력해주세요"
        case .invalidFormat(let field):
            return "\(field) 형식이 올바르지 않습니다"
        case .outOfRange(let field):
            return "\(field) 값이 범위를 벗어났습니다"
        }
    }
    
    var recoverySuggestion: String {
        return "입력값을 확인하고 다시 시도해주세요"
    }
}

extension DataError {
    var localizedDescription: String {
        switch self {
        case .notFound:
            return "요청한 데이터를 찾을 수 없습니다"
        case .saveFailure:
            return "데이터 저장에 실패했습니다"
        case .loadFailure:
            return "데이터 로드에 실패했습니다"
        case .corruptedData:
            return "데이터가 손상되었습니다"
        case .duplicateEntry:
            return "이미 존재하는 데이터입니다"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .notFound:
            return "다른 조건으로 검색하거나 새로 생성해보세요"
        case .saveFailure, .loadFailure:
            return "잠시 후 다시 시도해주세요"
        case .corruptedData:
            return "데이터를 다시 다운로드하거나 초기화해주세요"
        case .duplicateEntry:
            return "기존 데이터를 수정하거나 다른 값을 사용해주세요"
        }
    }
}

extension SystemError {
    var localizedDescription: String {
        switch self {
        case .memoryWarning:
            return "메모리 부족으로 인한 오류입니다"
        case .diskFull:
            return "저장 공간이 부족합니다"
        case .permissionDenied:
            return "권한이 거부되었습니다"
        case .unavailable:
            return "현재 사용할 수 없는 기능입니다"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .memoryWarning:
            return "앱을 재시작하거나 다른 앱을 종료해주세요"
        case .diskFull:
            return "저장공간을 확보하고 다시 시도해주세요"
        case .permissionDenied:
            return "설정에서 권한을 허용해주세요"
        case .unavailable:
            return "나중에 다시 시도해주세요"
        }
    }
}

// MARK: - Convenience Initializers
public extension AppError {
    static func network(_ error: NetworkError) -> AppError {
        .networkError(error)
    }
    
    static func auth(_ error: AuthError) -> AppError {
        .authenticationError(error)
    }
    
    static func validation(_ error: ValidationError) -> AppError {
        .validationError(error)
    }
    
    static func data(_ error: DataError) -> AppError {
        .dataError(error)
    }
    
    static func system(_ error: SystemError) -> AppError {
        .systemError(error)
    }
}