//
//  UnityApp.swift
//  Bythen
//
//  Created by edisurata on 06/09/24.
//

import Foundation
import UnityFramework

struct UnityMessage {
    let objectName: String?
    let methodName: String?
    let messageBody: String?
}

class UnityApp: NSObject, UnityFrameworkListener {
    private(set) static var instance: UnityApp?
    private var ufw: UnityFramework?
    private static var queueMessages = [UnityMessage]()
    
    static func initializeUnityApp() {
        if instance == nil {
            instance = UnityApp()
        } else {
            instance?.showUnityWindow()
            instance?.processMessages()
        }
    }
    
    static func getUnityView() -> UIView? {
        return instance?.ufw?.appController()?.rootViewController?.view
    }
    
    static func sendMessageToUnity(_ message: UnityMessage) {
        guard let instance = instance, instance.isUnityInitialized() else {
            UnityApp.addMessage(message)
            return
        }
        
        DispatchQueue.main.async {
            Logger.logInfo("from app: \(message)")
            instance.ufw?.sendMessageToGO(withName: message.objectName, functionName: message.methodName, message: message.messageBody)
        }
    }
    
    static func unloadApp() {
        instance?.ufw?.unloadApplication()
    }
    
    override init() {
        super.init()
        ufw = UnityFrameworkLoad()!
        ufw?.setDataBundleId("com.unity3d.framework")
        ufw?.register(self)
        ufw?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        ufw?.appController().window.isUserInteractionEnabled = false
        ufw?.appController().window.isHidden = true
        processMessages()
    }
    
    private func showUnityWindow() {
        ufw?.showUnityWindow()
        processMessages()
    }
    
    private func UnityFrameworkLoad() -> UnityFramework? {
        let bundlePath = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"
        guard let bundle = Bundle(path: bundlePath), !bundle.isLoaded else { return nil }
        
        bundle.load()
        let ufwInstance = bundle.principalClass?.getInstance()
        if ufwInstance?.appController() == nil {
//            var machHeader = UnsafeMutablePointer<MachHeader>.allocate(capacity: 1)
//            machHeader.pointee = _mh_execute_header
            let machHeader = #dsohandle.assumingMemoryBound(to: MachHeader.self)
            ufwInstance?.setExecuteHeader(machHeader)
        }
        return ufwInstance
    }
    
    private func isUnityInitialized() -> Bool {
        return ufw != nil && ufw?.appController() != nil
    }
    
    func unityDidUnload(_ notification: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
    }
    
    static func addMessage(_ message: UnityMessage) {
        UnityApp.queueMessages.append(message)
    }
    
    func processMessages() {
        guard let ufw = ufw else { return }
        for msg in UnityApp.queueMessages {
            ufw.sendMessageToGO(
                withName: msg.objectName,
                functionName: msg.methodName,
                message: msg.messageBody)
        }
        UnityApp.queueMessages.removeAll()
    }
    
    func pause(isPause: Bool) {
        guard let ufw = ufw else { return }
        ufw.pause(isPause)
    }
    
    static func pauseActivity() {
        guard let instance = instance else { return }
        instance.pause(isPause: true)
    }
    
    static func resumeActivityt() {
        guard let instance = instance else { return }
        instance.pause(isPause: false)
    }
}
