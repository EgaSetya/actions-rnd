//
//  Log.swift
//  Bythen
//
//  Created by edisurata on 26/09/24.
//

import Foundation
import SwiftyBeaver
import Sentry

class Logger {
    
    static private let instance = Logger()
    let log = SwiftyBeaver.self
    
    init() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $M $X"
        console.logPrintWay = .logger(subsystem: "Main", category: "UI")
        log.addDestination(console)
    }
    
    static func logDebug(_ message: Any, context: Any? = nil) {
        #if DEBUG
        instance.log.debug(message, context: context)
        #endif
    }
    
    static func logInfo(_ message: Any, context: Any? = nil) {
        #if DEBUG
        instance.log.info(message, context: context)
        #endif
    }
    
    static func logError(err: any Error, context: [String: Any]? = nil) {
        instance.log.error(err.localizedDescription, context: context)
        if let ctx = context {
            for (key, val) in ctx {
                let crumb = Breadcrumb(level: .info, category: "metadata")
                crumb.message = "\(key) : \(val)"
                SentrySDK.addBreadcrumb(crumb)
            }
            SentrySDK.capture(error: err)
        } else {
            SentrySDK.capture(error: err)
        }
        
    }
}
