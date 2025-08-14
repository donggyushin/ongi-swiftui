import Foundation

public struct ImageEntity {
    public let url: URL
    public let publicId: String
    
    public init(url: URL, publicId: String) {
        self.url = url
        self.publicId = publicId
    }
}
