//
//  MemoriesViewModel.swift
//  Bythen
//
//  Created by erlina ng on 06/10/24.
//

import SwiftUI

class MemoriesViewModel: BaseViewModel {
    private let memoryService: MemoryService = MemoryService()
    internal var byteBuild: ByteBuild
    @Published internal var isShowCheckBox: Bool = false
    @Published internal var selectedMemories: [Int64] = []
    @Published internal var memories: [Memory] = []
    
    internal init(byteBuild: ByteBuild) {
        self.byteBuild = byteBuild
        super.init()
    }
    
    internal func fetchMemories() {
        Task { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }
            
            do {
                let result = try await self.memoryService.getMemories(buildID: byteBuild.buildID)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.memories = result.memories
                    self.setLoading(isLoading: false)
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
    
    internal func deleteMemories() {
        Task { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }
            
            do {
                for memoryId in selectedMemories {
                    /// Using the first memory's buildID since all memories will have the same buildID
                    try await self.memoryService.deleteMemories(buildID: memories.first?.buildId ?? 0, memoryID: memoryId)
                }
                selectedMemories = []
                DispatchQueue.main.async {
                    self.setLoading(isLoading: false)
                }
                fetchMemories()
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
}

