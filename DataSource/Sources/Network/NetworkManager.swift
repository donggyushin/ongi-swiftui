import Foundation
import ThirdParty
import Alamofire

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let session: Session
    private let jwtLocalDataSource: JWTLocalDataSource
    
    private init() {
        self.jwtLocalDataSource = JWTLocalDataSource()
        let interceptor = JWTInterceptor()
        self.session = Session(interceptor: interceptor)
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
}

private final class JWTInterceptor: RequestInterceptor {
    
    private var jwtLocalDataSource: JWTLocalDataSource {
        return .init()
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if let accessToken = jwtLocalDataSource.getTokens()?.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("Content-Type", forHTTPHeaderField: "application/json")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        completion(.doNotRetry)
    }
}
