//
//  NotificationListViewModel.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/02/25.
//

import Combine
import SwiftUI

class NotificationListViewModel: BaseViewModel {
    private let paginationLimit: Int = 20
    // MARK: - Services
    private var notificationService: NotificationServiceProtocol
    
    @Published
    var pageState: NotificationListPageState = .initialLoading
    @Published
    var selectedFilter: NotificationListFilter = .all
    @Published
    var filterredItems: [String: [NotificationItemViewModel]] = [:]
    
    var page: [NotificationListFilter: Int] = [:]
    var isFilterLoaded: [NotificationListFilter: Bool] = [:]
    var allItems: [NotificationListFilter: [NotificationItemViewModel]] = [:]
    
    init(
        notificationService: NotificationServiceProtocol
    ) {
        self.notificationService = notificationService
        
        super.init()
        
        onFilterSelected(selectedFilter)
    }
    
    convenience init() {
        self.init(notificationService: NotificationService())
    }
    
    @MainActor
    func onAppear() async {
        recordVisit()
    }
    
    private func recordVisit() {
        Task {
            await notificationService.acknowledgeNotificationMark()
        }
    }
    
    func onFilterSelected(_ filter: NotificationListFilter) {
        Task { @MainActor in
            selectedFilter = filter
            var items = allItems[filter] ?? []
            
            if !(isFilterLoaded[filter] ?? false) && items.isEmpty {
                items = await loadData()
            }
            
            filterredItems = Dictionary(grouping: items) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                return dateFormatter.string(from: $0.createdAt)
            }
            
            if (isFilterLoaded[selectedFilter] ?? false) && items.isEmpty {
                pageState = .empty
            }
            else if !(isFilterLoaded[selectedFilter] ?? false) {
                pageState = .paginationLoading
            }
            else {
                pageState = .idle
            }
        }
    }
    
    @MainActor
    func loadMoreContent() async {
        var items = await loadData()
        filterredItems = Dictionary(grouping: items) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: $0.createdAt)
        }
        
        if (isFilterLoaded[selectedFilter] ?? false) && items.isEmpty {
            pageState = .empty
        }
        else if !(isFilterLoaded[selectedFilter] ?? false) {
            pageState = .paginationLoading
        }
        else {
            pageState = .idle
        }
    }
    
    private func loadData() async -> [NotificationItemViewModel] {
        do {
            let pageTo: Int = page[selectedFilter] ?? 1
            let response: [NotificationItemViewModel] = try await notificationService.getNotifications(page: pageTo, limit: paginationLimit, filter: selectedFilter)
                .map { NotificationItemViewModel(with: $0) }
            
            var existingData: [NotificationItemViewModel] = allItems[selectedFilter] ?? []
            existingData.append(contentsOf: response)
            page[selectedFilter] = (page[selectedFilter] ?? 1) + 1
            allItems[selectedFilter] = existingData
            return existingData
        }
        catch {
            return []
        }
    }
}


// TODO: Fardhan, tmp ViewModel
struct NotificationItemViewModel {
    let id: String = UUID().uuidString
    let type: NotificationListFilter
    let title: String
    let createdAt: Date
    init(with notificationItem: NotificationItem) {
        self.title = notificationItem.message
        self.type = notificationItem.group
        self.createdAt = notificationItem.createdAt
    }
}
