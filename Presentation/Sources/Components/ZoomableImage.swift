//
//  ZoomableImage.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import SwiftUI
import UIKit
import Kingfisher

// MARK: - UIKit ZoomableImageViewController
public class ZoomableImageViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupImageView()
        setupGestures()
        loadImage()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func setupGestures() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    private func loadImage() {
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self?.updateContentSize(for: value.image)
                }
            case .failure:
                break
            }
        }
    }
    
    private func updateContentSize(for image: UIImage) {
        let imageSize = image.size
        let scrollViewSize = scrollView.bounds.size
        
        // 이미지 비율을 유지하면서 스크롤뷰에 맞는 크기 계산
        let widthRatio = scrollViewSize.width / imageSize.width
        let heightRatio = scrollViewSize.height / imageSize.height
        let minRatio = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: imageSize.width * minRatio,
            height: imageSize.height * minRatio
        )
        
        scrollView.contentSize = scaledImageSize
        centerImage()
    }
    
    private func centerImage() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        imageView.center = CGPoint(
            x: scrollView.contentSize.width * 0.5 + offsetX,
            y: scrollView.contentSize.height * 0.5 + offsetY
        )
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            // 더블 탭 위치를 중심으로 확대
            let location = sender.location(in: imageView)
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale / 2, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // 최소 스케일로 리셋
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

// MARK: - SwiftUI Wrapper
public struct ZoomableImage: UIViewControllerRepresentable {
    
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> ZoomableImageViewController {
        return ZoomableImageViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: ZoomableImageViewController, context: Context) {
        // URL이 변경되면 새 이미지 로드
    }
}

#Preview {
    ZoomableImage(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755952248/profile-images/profile_gallery_001179.faeab893b42e4690857666203dccc57f.1606_1755952246788.jpg")!)
        .ignoresSafeArea()
}
