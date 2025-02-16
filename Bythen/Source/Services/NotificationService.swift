//
//  NotificationService.swift
//  Bythen
//
//  Created by Ega Setya on 08/01/25.
//

protocol NotificationServiceProtocol {
    func registerNotification(for token: String) async throws
    func getNotificationMark() async throws -> NoficationMarkResponse
    func acknowledgeNotificationMark() async
    func getNotifications(page: Int, limit: Int, filter: NotificationListFilter) async throws -> [NotificationItem]
}

class NotificationService: BythenApi, NotificationServiceProtocol {
    enum Endpoint: ApiEndpointProtocol {
        case registerToken
        case notificationMark
        case getNotificationList
        
        var path: String {
            switch self {
            case .registerToken:
                return "/v1/pn/tokens"
            case .notificationMark:
                return "/v1/accounts/notification"
            case .getNotificationList:
                return "/v1/notifications"
            }
        }
    }
    
    override init() {
        super.init(servicePath: AppConstants.ksMSCrm)
    }
    
    func registerNotification(for token: String) async throws {
        let deviceName = DeviceHelper.shared.deviceName
        
        let _: String = try await Http.post(
            fullUrl(Endpoint.registerToken),
            json: [
                "device_id": DeviceHelper.shared.deviceID,
                "device_name": "\(AppSession.shared.getCurrentAccount()?.username ?? "")'s \(DeviceHelper.shared.deviceName)",
                "device_version": deviceName,
                "platform": "iOS",
                "pn_token": token
            ],
            headers: try authHeaders()
        )
    }
    
    func getNotificationMark() async throws -> NoficationMarkResponse {
        return try await Http.get(
            fullUrl(Endpoint.notificationMark),
            headers: try authHeaders()
        )
    }
    
    func acknowledgeNotificationMark() async {
        do {
            let _: String? = try await Http.put(
                fullUrl(Endpoint.notificationMark),
                headers: try authHeaders()
            )
        } catch { }
    }
    
    func getNotifications(page: Int, limit: Int, filter: NotificationListFilter) async throws -> [NotificationItem] {
        var parameters: [String: Any] = [
            "page": page,
            "limit": limit,
            "sort_by": "created",
            "sort_mode": "desc"
        ]
        
        if filter != .all {
            parameters["group"] = filter.rawValue
        }
        return try await Http.get(
            fullUrl(Endpoint.getNotificationList),
            parameters: parameters,
            headers: try authHeaders()
        )
    }
}
