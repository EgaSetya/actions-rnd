//
//  AuthService.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import Foundation

protocol AuthServiceProtocol {
    func authLogout(account: Account)
    func loginWithEmail(email: String, password: String) async throws -> Account
    func getMe() async throws -> Account
    func setupAccount(json: [String: Any]) async throws
    func acceptTermsOfService(_ canBeContacted: Bool) async throws
    func authTwitter() async throws -> AuthTwitterResponse
    func connectTwitter(oauthToken: String, oatuhVerifier: String) async throws -> Account
    func disconnectTwitter() async throws -> Account
}

class AuthService: BythenApi, AuthServiceProtocol {
    private let kServicePath = "/ms/auth"
    
    enum Endpoint: ApiEndpointProtocol {
        case challenges
        case login
        case logout
        case loginEmail
        case me
        case authorizeTwitter
        case connectTwitter
        case disconnectTwitter
        case twitterAuth
        
        var path: String {
            switch self {
            case .challenges: return "/v1/challenges"
            case .login: return "/v1/login"
            case .logout: return "/v1/logout"
            case .loginEmail: return "/v1/login/email"
            case .me: return "/v1/me"
            case .authorizeTwitter: return "/v1/twitter_authorize"
            case .connectTwitter: return "/v1/twitter_oauth_connect"
            case .disconnectTwitter: return "/v1/twitter_disconnect"
            case .twitterAuth: return "/twitter-auth"
            }
        }
    }
    
    override init() {
        super.init(servicePath: kServicePath)
    }
    
    func challenges(address: String) async throws -> String {
        struct Challenge: Codable {
            var nonce: String
            
            enum CodingKeys: String, CodingKey {
                case nonce = "nonce"
            }
        }
        let response: Challenge = try await Http.post(
            fullUrl(Endpoint.challenges),
            json: ["wallet_public_key": address])
        
        return response.nonce
    }
    
    func authLogin(
        address: String,
        nonce: String,
        signature: String,
        referralCode: String?) async throws -> Account
    {
        return try await Http.post(
            fullUrl(Endpoint.login),
            json: [
                "wallet_public_key": address,
                "nonce": nonce,
                "signature": signature
            ])
    }
    
    func authLogout(account: Account) {
        struct LogoutResponse: Codable {
            var status: String
            
            enum CodingKeys: String, CodingKey {
                case status = "status"
            }
        }
        
        Task {
            do {
                let _: LogoutResponse = try await Http.post(
                    fullUrl(Endpoint.logout),
                    json: [
                        "account_id": account.accountID,
                        "account_type": "user",
                        "device_id": DeviceHelper.shared.deviceID,
                    ])
            } catch let err {
                
            }
        }
    }
    
    func loginWithEmail(email: String, password: String) async throws -> Account {
        let account: Account = try await Http.post(
            fullUrl(Endpoint.loginEmail),
            json: ["email": email, "password": password]
        )
        
        return account
    }
    
    func getMe() async throws -> Account {
        return try await Http.get(fullUrl(Endpoint.me), headers: try authHeaders())
    }
    
    func authTwitter() async throws -> AuthTwitterResponse {
        return try await Http.post(
            fullUrl(Endpoint.authorizeTwitter),
            json: ["redirect_uri": MissionConstant.twitterAuthURI],
            headers: try authHeaders())
    }
    func connectTwitter(oauthToken: String, oatuhVerifier: String) async throws -> Account {
        return try await Http.post(
            fullUrl(Endpoint.connectTwitter),
            json: ["oauth_token": oauthToken, "oauth_verifier": oatuhVerifier, "redirect_uri": MissionConstant.twitterAuthURI],
            headers: try authHeaders())
    }
    
    func disconnectTwitter() async throws -> Account {
        return try await Http.post(
            fullUrl(Endpoint.disconnectTwitter),
            headers: try authHeaders())
    }
    
    func setupAccount(json: [String: Any]) async throws {
        let _: EmptyBody = try await Http.put(
            fullUrl(Endpoint.me),
            json: json,
            headers: try authHeaders()
        )
    }
    
    func acceptTermsOfService(_ canBeContacted: Bool) async throws {
        let parameter = [
            "is_agreement_approved": true,
            "can_be_contacted": canBeContacted
        ]
        let _: EmptyBody = try await Http.put(fullUrl(Endpoint.me), json: parameter, headers: try authHeaders())
    }
}

struct AuthTwitterResponse: Codable {
    let authorizationURI: String
    
    enum CodingKeys: String, CodingKey {
        case authorizationURI = "authorization_uri"
    }
}
