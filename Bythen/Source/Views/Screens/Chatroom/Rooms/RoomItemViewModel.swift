//
//  RoomItemViewModel.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import Foundation

class RoomItemViewModel: BaseViewModel {
    
    typealias RoomHandler = (_ room: Room) -> Void
    
    @Published var isSelected: Bool = false
    @Published var highlightedText: String?
    
    var title: String
    var description: String
    var isPrimary: Bool
    var roomID: Int64
    
    var didDeleteRoom: RoomHandler
    var didSelectRoom: RoomHandler
    var didRenameRoom: RoomHandler
    
    private var room: Room
    
    init(
        room: Room,
        index: Int,
        isSelected: Bool = false,
        highlightedText: String? = nil,
        didSelectRoom: @escaping RoomHandler = { room in },
        didDeleteRoom: @escaping RoomHandler = { room in },
        didRenameRoom: @escaping RoomHandler = { room in })
    {
        self.room = room
        self.roomID = room.roomID
        self.title = room.title
        self.description = room.summary
        self.isPrimary = room.isPrimary
        self.isSelected = isSelected
        self.didSelectRoom = didSelectRoom
        self.didDeleteRoom = didDeleteRoom
        self.didRenameRoom = didRenameRoom
        self.highlightedText = highlightedText
        super.init(index: index)
    }
    
    func deleteRoomAction() {
        self.didDeleteRoom(self.room)
    }
    
    func renameRoomAction() {
        self.didRenameRoom(self.room)
    }
    
    func selectRoomAction() {
        if self.isSelected {
            return
        }
        self.didSelectRoom(self.room)
        self.isSelected = true
    }
}
