//
//  ZoomableImage.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import SwiftUI
import UIKit
import Kingfisher
import SnapKit

class ZoomableImageViewController: UIViewController, UIScrollViewDelegate {
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false 
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
        
        imageView.contentMode = .scaleAspectFill
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.height.equalTo(view)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setImage(_ url: URL?) {
        imageView.kf.setImage(with: url)
    }

    @available(iOS 2.0, *)
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

struct ZoomableImageViewControllerRepresentable: UIViewControllerRepresentable {
    
    let source: URL?
    
    func makeUIViewController(context: Context) -> ZoomableImageViewController {
        let controller = ZoomableImageViewController()
        controller.setImage(source)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ZoomableImageViewController, context: Context) {
        uiViewController.setImage(source)
    }
}

public struct ZoomableImage: View {
    
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
//        KFImage(url)
//            .resizable()
//            .scaledToFit()
        
        
        ZoomableImageViewControllerRepresentable(source: url)
            .ignoresSafeArea()
        
    }
}

#Preview {
    ZoomableImage(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755952248/profile-images/profile_gallery_001179.faeab893b42e4690857666203dccc57f.1606_1755952246788.jpg")!)
        .ignoresSafeArea()
}
