//
//  FakeUnityEmbedded.swift
//  Bythen
//
//  Created by edisurata on 30/07/24.
//

import Foundation
import UIKit

extension UIImageView{
    func imageFrom(url: String){
        if let imageURL = URL(string: url) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL){
                    if let image = UIImage(data:data){
                        DispatchQueue.main.async{
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}

struct UnityMessage {
    let objectName: String?
    let methodName: String?
    let messageBody: String?
}

class UnityApp {
    private(set) static var instance: UnityApp?
    private var mainView: UIView = UIView()
    private var avatar: UIImageView = UIImageView()
    private var bgImage: UIImageView = UIImageView()
    
    static func initializeUnityApp() {
        if instance == nil {
            instance = UnityApp()
            if let instance = instance {
                instance.mainView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                instance.bgImage = UIImageView(frame: instance.mainView.frame)
                instance.mainView.addSubview(instance.bgImage)
                instance.bgImage.isHidden = true
                instance.bgImage.contentMode = .scaleToFill
                instance.avatar.frame = instance.mainView.frame
                instance.avatar.image = UIImage(named: "mock-azuki")
                instance.avatar.contentMode = .center
                instance.mainView.addSubview(instance.avatar)
            }
        }
    }
    
    static func getUnityView() -> UIView? {
        guard let instance else { return nil }
        return instance.mainView
    }
    
    static func sendMessageToUnity(_ message: UnityMessage) {
        Logger.logInfo("Unity send message: \(message.messageBody ?? "")")
        guard let instance else { return }
        if let jsonData = message.messageBody?.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if ((json["event"] as? String) ?? "").contains("change-character")  {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            NotificationCenter.default.post(name: UnityEventSignal.loadingScreenHidden.getNotificationName(), object: nil, userInfo: [:])
                        }
                    } else if ((json["event"] as? String) ?? "").contains("app/change-background-color") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            instance.mainView.backgroundColor = UIColor(hex: (((json["data"] as! [String: String?])["hexColor"] ?? "")!))
                            instance.bgImage.isHidden = true
                        }
                    } else if ((json["event"] as? String) ?? "").contains("app/change-background-image") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            instance.bgImage.imageFrom(url: (((json["data"] as! [String: String?])["imageUri"] ?? "")!))
                            instance.bgImage.isHidden = false
                        }
                    }
                }
            } catch {
                print("Failed to convert JSON string to Dictionary: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    NotificationCenter.default.post(name: UnityEventSignal.loadingScreenHidden.getNotificationName(), object: nil, userInfo: [:])
                }
            }
        }
    }
    
    static func pauseActivity() {
    }
    
    static func resumeActivityt() {
    }
}
