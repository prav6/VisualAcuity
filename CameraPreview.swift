//
//  CameraPreview.swift
//  Visual Acuity Test
//
//  Created by Praveen Chandrarajah on 15/04/2024.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        if let previewLayer = cameraManager.videoPreviewLayer {
            previewLayer.frame = view.frame
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update logic if needed
    }
}

