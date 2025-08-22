//
//  SideMenuSection.swift
//  Bythen
//
//  Created by Ega Setya on 23/12/24.
//

import Foundation

protocol SideMenuSection: CaseIterable {
    var header: String { get }
    var detail: (title: String, iconName: String, page: MenuPage?, url: URL?) { get }
}

enum SideMenuMainSection: SideMenuSection {
    case home
    case myCollection
    
    var header: String { "" }
    var detail: (title: String, iconName: String, page: MenuPage?, url: URL?) {
        switch self {
        case .home: ("Chatroom", "home", .chat, nil)
        case .myCollection: ("My Collection", "collections", .mycollection, nil)
        }
    }
}

enum SideMenuStudioSection: SideMenuSection {
    case directorsMode
    case byteAsMe
    case liveStream
    
    var header: String { "STUDIO APATU" }
    var detail: (title: String, iconName: String, page: MenuPage?, url: URL?) {
        switch self {
        case .directorsMode: ("Director's Mode", "clapper-board-play.sharp.regular", .studio, nil)
        case .byteAsMe: ("Byte as Me", "person-rays.sharp.regular", nil, nil)
        case .liveStream: ("Livestream", "camera-web.sharp.regular", nil, nil)
        }
    }
}

enum SideMenuHiveSection: String, SideMenuSection {
    case summary
    case mission
    case earnings
    case tutorial
    case leaderboard
    
    var header: String { "HIVE" }
    var detail: (title: String, iconName: String, page: MenuPage?, url: URL?) {
        var title: String? = nil
        let iconName: String
        let page: MenuPage?
        var url: URL? = nil
        
        switch self {
        case .summary:
            title = "My Hive"
            iconName = "hive-icon"
            page = .hive
        case .mission:
            iconName = "rocket-launch-icon"
            page = .mission
        case .earnings:
            iconName = "earnings"
            page = .hiveEarnings
        case .tutorial:
            iconName = "tutorial-icon"
            page = nil
            url = URL(string: "https://bythen-ai.gitbook.io/byteshive-guide")
        case .leaderboard:
            iconName = "leaderboard"
            page = .hiveLeaderboard
        }
        
        return (title ?? self.rawValue.capitalized, iconName, page, url: url)
    }
    
    static func getEnabledHiveSection() -> [SideMenuHiveSection] {
        var menu: [SideMenuHiveSection] = []
        menu.append(.summary)
        menu.append(.leaderboard)
        if FeatureFlag.sideMenuMission.isFeatureEnabled() {
            menu.append(.mission)
        }
        if FeatureFlag.withdrawal.isFeatureEnabled() {
            menu.append(earnings)
        }
        menu.append(.tutorial)
        
        return menu
    }
}
