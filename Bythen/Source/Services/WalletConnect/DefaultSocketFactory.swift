//
//  DefaultSocketFactory.swift
//  Bythen
//
//  Created by edisurata on 28/08/24.
//

import Foundation
import Starscream
import WalletConnectRelay

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        let socket = WebSocket(url: url)
        let queue = DispatchQueue(label: "com.walletconnect.sdk.sockets", qos: .utility, attributes: .concurrent)
        socket.callbackQueue = queue
        return socket
    }
}
