//
//  RoomsViewModel.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import Foundation

enum RoomsViewAlert {
    case deleteRoom(room: Room)
    case renameRoom(room: Room)
    case hidden
    
    var content: String? {
        switch self {
        case .deleteRoom(let room): return "This will delete \(room.title) and cannot be recovered."
        default:
            return nil
        }
    }
    
    var editText: String? {
        switch self {
        case .renameRoom(let room): return room.title
        default:
            return nil
        }
    }
}

class RoomsViewModel: BaseViewModel {
    
    typealias SelectByteHandler = (Byte) -> Void
    typealias SelectRoomHandler = (Room) -> Void
    
    static func new(buildID: Int64, byteID: Int64, selectByteAction: @escaping SelectByteHandler, selectRoomAction: @escaping SelectRoomHandler) -> RoomsViewModel {
        return RoomsViewModel(
            buildID: buildID,
            byteID: byteID,
            roomService: RoomService(),
            byteService: ByteService(),
            byteBuildService: ByteBuildService(),
            selectByteAction: selectByteAction,
            selectRoomAction: selectRoomAction
        )
    }
    
    @Published var searchText: String = ""
    @Published var byteItems: [ByteItemViewModel] = []
    @Published var roomItems: [RoomItemViewModel] = []
    @Published var selectedByte: Byte?
    @Published var selectedRoom: Room?
    @Published var triggerNewRoom: Bool = false
    @Published var roomsAlert: RoomsViewAlert = .hidden
    @Published var deleteRoomAlertContent: String = ""
    @Published var isShowBackground: Bool = false
    
    var selectByteAction: (_ byte: Byte) -> Void
    var selectRoomAction: (_ room: Room) -> Void
    var isDataReady: Bool = false
    var roomForDelete: Room?
    var roomForUpdate: Room?
    
    private var rooms: [Room] = []
    private var bytes: [Byte] = []
    private var roomService: RoomServiceProtocol
    private var buildID: Int64
    private var byteService: ByteServiceProtocol
    private var byteBuildService: ByteBuildServiceProtocol
    private var isCreatingRoom: Bool = false
    private var byteID: Int64
    
    init(
        buildID: Int64,
        byteID: Int64,
        roomService: RoomServiceProtocol,
        byteService: ByteServiceProtocol,
        byteBuildService: ByteBuildServiceProtocol,
        selectByteAction: @escaping SelectByteHandler,
        selectRoomAction: @escaping SelectRoomHandler
    ) {
        self.buildID = buildID
        self.byteID = byteID
        self.roomService = roomService
        self.byteService = byteService
        self.byteBuildService = byteBuildService
        self.selectByteAction = selectByteAction
        self.selectRoomAction = selectRoomAction
        super.init()
    }
    
    func searchRooms() {
        if searchText.isEmpty {
            generateRoomsVM(rooms: rooms)
            return
        }
        
        let filteredRooms = self.rooms.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.summary.localizedCaseInsensitiveContains(searchText)}
        
        generateRoomsVM(rooms: filteredRooms)
    }
    
    func searchBytes() {
        if searchText.isEmpty {
            generateByteItems(bytes: bytes)
            return
        }
        
        let filteredBytes = self.bytes.filter { $0.byteName.localizedCaseInsensitiveContains(searchText) || $0.role.localizedCaseInsensitiveContains(searchText) }
        
        generateByteItems(bytes: filteredBytes)
    }
    
    func createNewRoom() {
        if self.isCreatingRoom {
            return
        }
        
        let emptyRoom = Room(roomID: 0, title: "New Chat")
        self.selectedRoom = emptyRoom
        self.selectRoomAction(emptyRoom)
    }
    
    // MARK: - UI
    
    private func generateRoomsVM(rooms: [Room]) {
        var newRooms: [RoomItemViewModel] = []
        var isHasSelection: Bool = false
        for (index, room) in rooms.enumerated() {
            var isSelected = false
            if let selection = self.selectedRoom, selection.roomID == room.roomID {
                isHasSelection = true
                isSelected = true
            }
            let vm = RoomItemViewModel(
                room: room,
                index: index,
                isSelected: isSelected,
                highlightedText: self.searchText != "" ? self.searchText : nil,
                didSelectRoom: self.selectRoom(room:),
                didDeleteRoom: self.prepareDeleteRoom(room:),
                didRenameRoom: self.prepareRenameRoom(room:)
            )
            newRooms.append(vm)
        }
        
        if !isHasSelection {
            if let selection = self.selectedRoom, selection.roomID == 0 {
                
            } else {
                if let firstRoom = rooms.first {
                    self.selectedRoom = firstRoom
                }
                
                if let vm = newRooms.first {
                    vm.isSelected = true
                }
            }
        }
        
        self.roomItems = newRooms
    }
    
    private func generateByteItems(bytes: [Byte]) {
        var newByteItems: [ByteItemViewModel] = []
        var isHasSelection: Bool = false
        
        for (index, byte) in bytes.enumerated() {
            var isSelected = false
            if let selection = self.selectedByte, selection.byteData.byteID == byte.byteData.byteID {
                isHasSelection = true
                isSelected = true
            }
            let vm = ByteItemViewModel(
                byte: byte,
                index: index,
                isSelected: isSelected,
                highlightedText: self.searchText != "" ? self.searchText : nil,
                didSelectByte: self.selectByte(_:),
                didSetAsPrimary: self.setBuildAsPrimary(_:)
            )
            newByteItems.append(vm)
        }
        
        if !isHasSelection {
            for byte in bytes {
                if byte.byteData.byteID == self.byteID {
                    self.selectedByte = byte
                    break
                }
            }
            
            for vm in newByteItems {
                if vm.byteID == self.byteID {
                    vm.isSelected = true
                    break
                }
            }
        }
        
        self.byteItems = newByteItems
    }
    
    private func deselectAllRooms() {
        for item in roomItems {
            item.isSelected = false
        }
    }
    
    private func deselectAllBytes() {
        for item in byteItems {
            item.isSelected = false
        }
    }
    
    // MARK: - Network
    
    func fetchData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer {
                self.setLoading(isLoading: false)
            }

            self.setLoading(isLoading: true)
            
            do {
                if !isDataReady {
                    async let fetchBytesTask: Void = self.fetchBytes()
                    async let fetchRoomsTask: Void = self.fetchRooms()
                    
                    (_, _) = try await (fetchBytesTask, fetchRoomsTask)
                    self.isDataReady = true
                } else {
                    try await self.fetchRooms()
                }
            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func fetchRooms() async throws {
        let resp = try await self.roomService.getRooms(buildID: self.buildID)
        DispatchQueue.main.async {
            if resp.rooms.count > 0 {
                self.rooms = resp.rooms
                self.generateRoomsVM(rooms: self.rooms)
            }
        }
    }
    
    private func fetchBytes() async throws {
        let resp = try await self.byteService.getBytes()
        DispatchQueue.main.async {
            if resp.bytes.count > 0 {
                self.bytes = resp.bytes
                self.generateByteItems(bytes: self.bytes)
            }
        }
    }
    
    func deleteRooms() {
        guard let room = self.roomForDelete else { return }
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await self.roomService.deleteRooms(buildID: self.buildID, roomID: room.roomID)
                if let index = self.rooms.firstIndex(where: { $0.roomID == room.roomID }) {
                    self.rooms.remove(at: index)
                    if let selection = self.selectedRoom, selection.roomID == room.roomID {
                        if let firstroom = self.rooms.first {
                            self.selectRoom(room: firstroom)
                        }
                    }
                    self.generateRoomsVM(rooms: self.rooms)
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    func updateRooms(newTitle: String) {
        guard let room = self.roomForUpdate else { return }
        Task {@MainActor [weak self] in
            guard let self else { return }
            do {
                try await self.roomService.updateRooms(buildID: self.buildID, roomID: room.roomID, params: RoomUpdateParams(title: newTitle))
                if let idx = self.rooms.firstIndex(where: { $0.roomID == room.roomID }) {
                    self.rooms[idx].title = newTitle
                    self.generateRoomsVM(rooms: self.rooms)
                }
            } catch let err as HttpError {
                self.handleError(err)
            }
        }
    }
    
    func setBuildAsPrimary(_ byte: Byte) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await self.byteBuildService.setBuildAsPrimary(byteID: byte.byteData.byteID, byteSymbol: byte.byteData.byteSymbol)
                for item in self.byteItems {
                    item.isPrimary = item.byteID == byte.byteData.byteID
                }
            } catch let err {
                self.handleError(err)
            }
        }
    }
    
    // MARK: - Actions
    
    func filterBytesAndRooms(filterText: String) {
        self.searchBytes()
        self.searchRooms()
    }
    
    private func prepareDeleteRoom(room: Room)  {
        self.roomsAlert = .deleteRoom(room: room)
        self.roomForDelete = room
    }
    
    private func prepareRenameRoom(room: Room)  {
        self.roomsAlert = .renameRoom(room: room)
        self.roomForUpdate = room
    }
    
    private func selectRoom(room: Room) {
        self.selectedRoom = room
        self.deselectAllRooms()
        self.isShowBackground = false
        self.selectRoomAction(room)
    }
    
    private func selectByte(_ byte: Byte) {
        self.selectedByte = byte
        self.buildID = byte.buildID
        self.deselectAllBytes()
        self.isShowBackground = false
        Task {
            try await self.byteBuildService.updateBuildUsed(buildID: byte.buildID)
        }
        self.selectByteAction(byte)
    }
    
}
