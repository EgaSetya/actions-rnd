//
//  WalletConnect.swift
//  Bythen
//
//  Created by edisurata on 29/08/24.
//

import Foundation
import ReownAppKit
import Combine
import Web3
import UIKit

class WalletConnect: ObservableObject {
    
    static let shared : WalletConnect = WalletConnect()
    
    private var cancellables = Set<AnyCancellable>()
    
    internal let walletConnectedSubject = PassthroughSubject<String, Never>()
    var walletConnectedPublisher: AnyPublisher<String, Never> {
        walletConnectedSubject.eraseToAnyPublisher()
    }
    
    internal let accountSignedSubject = PassthroughSubject<String, Never>()
    var accountSignedPublisher: AnyPublisher<String, Never> {
        accountSignedSubject.eraseToAnyPublisher()
    }
    
    init() {}
    
    func setup() {
        let metadata = AppMetadata(
            name: "Bythen",
            description: "Bythen App",
            url: "https://www.bythen.ai",
            icons: ["https://avatars.githubusercontent.com/u/37784886"],
            redirect: try! AppMetadata.Redirect(native: "bythen://", universal: nil, linkMode: false)
        )
        
        let requiredNamespaces: [String: ProposalNamespace] = [
            "eip155": ProposalNamespace(
                chains: [
                    Blockchain("eip155:1")!
                ],
                methods: [
                    "eth_sendTransaction",
                    "personal_sign",
                    "eth_signTypedData"
                ], events: []
            )
        ]
        
        Networking.configure(
            groupIdentifier: AppConfig.appGroupIdentifier,
            projectId: AppConfig.walletConnectProjectID,
            socketFactory: DefaultSocketFactory()
        )
        
        AppKit.configure(
            projectId:  AppConfig.walletConnectProjectID,
            metadata: metadata,
            crypto: DefaultCryptoProvider(),
            sessionParams: .init(requiredNamespaces: requiredNamespaces),
            authRequestParams: nil
        )
    }
    
    func startListenToPublisher() {
        AppKit.instance.sessionSettlePublisher.sink { [weak self] session in
            guard let self = self else { return }
            if let account = session.accounts.first {
                do {
                    let ethAddress = try EthereumAddress(hex: account.address, eip55: false)
                    let eip55EthAddress = ethAddress.hex(eip55: true)
                    print("Connected Address: \(eip55EthAddress)")
                    self.walletConnectedSubject.send(eip55EthAddress)
                } catch {
                    
                }
            }
        }.store(in: &cancellables)

        AppKit.instance.sessionResponsePublisher.sink { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .response(let anyCodable):
                if let signature = anyCodable.value as? String {
                    self.accountSignedSubject.send(signature)
                } else {
                    print("error get signature")
                }
            case .error(let error):
                print("error: \(error)")
            }
           
        }.store(in: &cancellables)
    }
    
    func getConnectedAccountAddress() -> String? {
        let sessions = AppKit.instance.getSessions()
        guard let session = sessions.first else { return nil}
        guard let account = session.accounts.first else {return nil}
        do {
            let ethAddress = try EthereumAddress(hex: account.address, eip55: false)
            let eip55EthAddress = ethAddress.hex(eip55: true)
            print("Connected Address: \(eip55EthAddress)")
            return eip55EthAddress
        } catch {
            return nil
        }
        
    }
    
    func signWithConnectedAccount(nonce: String) {
        if let address = self.getConnectedAccountAddress() {
            Task {
                do {
                    try await AppKit.instance.request(.personal_sign(address: address, message: nonce))
                    if await UIApplication.shared.applicationState == .active {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            AppKit.instance.launchCurrentWallet()
                        }
                    }
                } catch let error {
                    print("Caught an error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func disconnectWallet() {
        Task {
            do {
                try await AppKit.instance.cleanup()
            } catch let err {
                
            }
        }
    }
//
//    func presentModal(on vc: UIViewController) {
//        Web3Modal.set(sessionParams: .init(
//            requiredNamespaces: requiredNamespaces
//        ))
//        
//        Web3Modal.present(from: vc)
//    }
}
