import Foundation
import ThirdParty
import Alamofire
import os.log

public extension Notification.Name {
    static let userShouldLogout = Notification.Name("userShouldLogout")
}

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let session: Session
    private let jwtLocalDataSource: JWTLocalDataSource
    
    public var isLoggingEnabled: Bool = true {
        didSet {
            NetworkLogger.shared.isEnabled = isLoggingEnabled
        }
    }
    
    private init() {
        self.jwtLocalDataSource = JWTLocalDataSource()
        let interceptor = JWTInterceptor()
        let logger = NetworkLogger.shared
        self.session = Session(interceptor: interceptor, eventMonitors: [logger])
    }
    
    public func request<T: Decodable>(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func upload<T: Decodable>(
        url: URLConvertible,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: multipartFormData,
                to: url,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

private final class NetworkLogger: EventMonitor {
    static let shared = NetworkLogger()
    
    private let logger = Logger(subsystem: "com.ongi.swiftui", category: "Network")
    private let _isEnabled = OSAllocatedUnfairLock(initialState: true)
    
    var isEnabled: Bool {
        get { _isEnabled.withLock { $0 } }
        set { _isEnabled.withLock { $0 = newValue } }
    }
    
    private init() {}
    
    func requestDidResume(_ request: Request) {
        guard isEnabled else { return }
        
        let method = request.request?.httpMethod ?? "Unknown"
        let url = request.request?.url?.absoluteString ?? "Unknown URL"
        let headers = request.request?.allHTTPHeaderFields ?? [:]
        
        logger.info("🚀 Request Started:")
        logger.info("Method: \(method)")
        logger.info("URL: \(url)")
        logger.info("Headers: \(String(describing: headers))")
        
        if let body = request.request?.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.info("Body: \(bodyString)")
        }
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard isEnabled else { return }
        
        let statusCode = response.response?.statusCode ?? 0
        let url = response.request?.url?.absoluteString ?? "Unknown URL"
        
        logger.info("📥 Response Received:")
        logger.info("URL: \(url)")
        logger.info("Status Code: \(statusCode)")
        
        if let headers = response.response?.allHeaderFields {
            logger.info("Response Headers: \(headers)")
        }
        
        if let data = response.data,
           let responseString = String(data: data, encoding: .utf8) {
            logger.info("Response Body: \(responseString)")
        }
        
        if let error = response.error {
            logger.error("❌ Request Failed: \(error.localizedDescription)")
        } else {
            logger.info("✅ Request Succeeded")
        }
    }
}

private final class JWTInterceptor: RequestInterceptor {
    
    private var jwtLocalDataSource: JWTLocalDataSource {
        return .init()
    }
    
    private var jwtRepository: JWTRepository {
        return JWTRepository.shared
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if let accessToken = jwtLocalDataSource.getTokens()?.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        Task {
            do {
                try await jwtRepository.refreshToken()
                completion(.retryWithDelay(1))
            } catch {
                // 토큰 갱신 실패 시 로그아웃 이벤트 발송
                NotificationCenter.default.post(name: .userShouldLogout, object: nil)
                completion(.doNotRetry)
            }
        }
    }
}
