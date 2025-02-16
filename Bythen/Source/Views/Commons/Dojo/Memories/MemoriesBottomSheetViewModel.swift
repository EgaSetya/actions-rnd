//
//  MemoriesBottomSheetViewModel.swift
//  Bythen
//
//  Created by erlina ng on 8/10/24.
//

import SwiftUI

class MemoriesBottomSheetViewModel: BaseViewModel {
    private let memoryService: MemoryService = MemoryService()
    @Published var memory: Memory
    
    init(memory: Memory) {
        self.memory = memory
    }
    
    internal func setMemoryNameLimit(newValue: String) {
        memory.name = String(newValue.prefix(150))
    }
    
    internal func updateMemory() {
        Task { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.setLoading(isLoading: true)
            }
            
            do {
                try await self.memoryService.updateMemories(buildID: memory.buildId, memoryID: memory.id, memory: memory.name)
                DispatchQueue.main.async {
                    self.setLoading(isLoading: false)
                }
            } catch let err as HttpError {
                DispatchQueue.main.async {
                    self.handleError(err)
                }
            }
        }
    }
}
