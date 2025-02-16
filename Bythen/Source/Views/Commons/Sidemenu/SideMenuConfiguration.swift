//
//  SideMenuConfiguration.swift
//  Bythen
//
//  Created by Ega Setya on 24/12/24.
//


struct SideMenuConfiguration {
    let mainSections: [SideMenuMainSection]?
    let studioSections: [SideMenuStudioSection]?
    let hiveSections: [SideMenuHiveSection]?
    
    private static var shouldShowHive: Bool {
        FeatureFlag.releaseHive.isFeatureEnabled()
    }
    
    static func `default`() -> SideMenuConfiguration {
        self.init(mainSections: SideMenuMainSection.allCases, studioSections: [.directorsMode], hiveSections: shouldShowHive ? SideMenuHiveSection.getEnabledHiveSection() : nil)
    }
    
    static func `hiveOnly`() -> SideMenuConfiguration { 
        self.init(mainSections: nil, studioSections: nil, hiveSections: shouldShowHive ? SideMenuHiveSection.getEnabledHiveSection() : nil)
    }
}
