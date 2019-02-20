//
//  PhotoProvider.swift
//  photo_provider
//
//  Created by apple on 2019/1/3.
//

import Photos
import UIKit

class PhotoProvider {
    static let shared = PhotoProvider()
    var hasPermission = false
    private var assetsFetchResults: PHFetchResult<PHAsset>!
    private let imageManager = PHCachingImageManager.default()
    var photosCount: Int {
        get {
            return assetsFetchResults.count
        }
    }
    func initPhotoProvider() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            hasPermission = true
            loadAllPhoto()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                self.initPhotoProvider()
            }
        case .denied:
            print("手动开启权限")
        case .restricted:
            print("无法开启权限")
        }
    }
    private lazy var phFetchOptions: PHFetchOptions = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return allPhotosOptions
    }()
    private func loadAllPhoto() {
        guard hasPermission else { return }
        assetsFetchResults = PHAsset.fetchAssets(with: .image, options: phFetchOptions)
    }
    func getImage(at index: Int, width: Int?, height: Int?, compress: Int?, result: @escaping FlutterResult) {
        guard index < photosCount else { return }
        let asset = assetsFetchResults[index]
        let thumbWidth = width ?? asset.pixelWidth
        let thumbHeight = height ?? asset.pixelHeight
        let thumbCompress = compress ?? 80
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: thumbWidth, height: thumbHeight),
                                  contentMode: .default,
                                  options: nil) { (image, info) in
                                    guard let `image` = image else {
                                        result(nil)
                                        return
                                    }
                                    result(image.jpegData(compressionQuality: CGFloat(thumbCompress)))
        }
    }
}
