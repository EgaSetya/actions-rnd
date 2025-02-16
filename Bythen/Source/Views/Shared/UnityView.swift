//
//  UnityView.swift
//  Bythen
//
//  Created by edisurata on 06/09/24.
//

import SwiftUI

struct UnityView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        // Start the Unity app if it's not already running
        // Get the Unity view
        if let unityView = UnityApp.getUnityView() {
            unityView.isUserInteractionEnabled = true
            return unityView
        } else {
            // Return an empty view if Unity view is not available
            return UIView()
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle any updates to the view if necessary
        uiView.setNeedsLayout()
    }
}

//struct UnityView: UIViewControllerRepresentable {
//    
//    @State var backgroundHexColor: String?
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let unityViewController = UIViewController()
//        // Start the Unity app if it's not already running
//        UnityApp.initializeUnityApp()
//        
//        // Get the Unity view
//        if let unityView = UnityApp.getUnityView() {
//            unityView.isUserInteractionEnabled = false
//            unityViewController.view.addSubview(unityView)
//            unityView.frame = unityViewController.view.bounds
//            unityView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        }
//        
//        return unityViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // Update logic for Unity view if needed
//    }
//}
