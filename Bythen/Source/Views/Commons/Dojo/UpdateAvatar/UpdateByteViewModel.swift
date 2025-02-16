//
//  UpdateByteViewModel.swift
//  Bythen
//
//  Created by edisurata on 04/10/24.
//

import Foundation
import Combine

class UpdateByteViewModel: BaseViewModel {
    
    static func new(byteBuild: ByteBuild = ByteBuild()) -> UpdateByteViewModel {
        return UpdateByteViewModel(byteBuild: byteBuild, byteBuildService: ByteBuildService())
    }
    
    @Published var byteName: String = ""
    @Published var byteAge: String = ""
    @Published var byteGender: ByteGender = .empty
    @Published var byteRole: String = ""
    @Published var isSubmitEnabled: Bool = false
    
    private var successUpdateSubject = PassthroughSubject<ByteBuild, Never>()
    var successUpdateSignal: AnyPublisher<ByteBuild, Never> {
        get {
            return successUpdateSubject.eraseToAnyPublisher()
        }
    }
    
    private var byteBuild: ByteBuild
    private var byteBuildService: ByteBuildServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(byteBuild: ByteBuild, byteBuildService: ByteBuildServiceProtocol) {
        self.byteBuild = byteBuild
        self.byteBuildService = byteBuildService
        super.init()
        self.byteName = byteBuild.byteName
        self.byteAge = "\(byteBuild.age)"
        self.byteGender = byteBuild.gender
        self.byteRole = byteBuild.role
    }
    
    func updateAvatar(completion: @escaping () -> Void) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer {
                self.setLoading(isLoading: false)
            }
            
            self.setLoading(isLoading: true)
            
            let params = UpdateByteBuildProfileParams(
                byteName: self.byteName,
                gender: self.byteGender.rawValue,
                age: Int64(self.byteAge) ?? 0,
                role: self.byteRole
            )
            do {
                try await self.byteBuildService.updateByteProfile(
                    byteID: self.byteBuild.byteId,
                    byteSymbol: self.byteBuild.byteSymbol,
                    params: params
                )
                self.byteBuild.byteName = self.byteName
                self.byteBuild.age = Int64(self.byteAge) ?? 0
                self.byteBuild.gender = self.byteGender
                self.byteBuild.role = self.byteRole
                self.successUpdateSubject.send(self.byteBuild)
                completion()
            } catch let err {
                self.handleError(err)
            }
        }
    }
    
    func validatingSubmitButton() {
        $byteName.combineLatest($byteAge, $byteGender, $byteRole)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (name, age, gender, role) in
                guard let self else { return }
                self.isSubmitEnabled = !name.isEmpty && !age.isEmpty && gender != .empty && !role.isEmpty
            }
            .store(in: &cancellables)
    }
}
