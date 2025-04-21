//
//  MediaPickerView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI
import PhotosUI

public protocol MediaPickerSource: AnyObject {
    var media: Binding<[IImage]> { get }
}

public struct MediaPickerView: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = PHPickerViewController
    
    @Binding private var media: [IImage]
    private var selectionLimit: Int
    private var filter: PHPickerFilter?
    private var itemProviders: [NSItemProvider]
    
    public init(
        media: Binding<[IImage]>,
        selectionLimit: Int = 5,
        filter: PHPickerFilter? = PHPickerFilter.any(of: [.images]),
        itemProviders: [NSItemProvider] = []
    ) {
        self._media = media
        self.selectionLimit = selectionLimit
        self.filter = filter
        self.itemProviders = itemProviders
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = self.filter
        configuration.selectionLimit = self.selectionLimit
        configuration.selection = .ordered
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        return MediaPickerView.Coordinator(parent: self)
    }
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: MediaPickerView
        
        init(parent: MediaPickerView) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard !results.isEmpty else { return }

            parent.itemProviders = results.map(\.itemProvider)

            loadMedia()
        }
        
        private func loadMedia() {
            var loadedMedia: [IImage] = []
            let group = DispatchGroup()

            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            let wrapped = IImage(src: MyImageEnum.local(image))
                            loadedMedia.append(wrapped)
                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                self.parent.media = loadedMedia
            }
        }
    }
}

#Preview {
    MediaPickerView(media: .constant([]))
}
