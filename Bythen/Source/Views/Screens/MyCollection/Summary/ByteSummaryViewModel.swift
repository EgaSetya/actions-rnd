//
//  ByteSummaryViewModel.swift
//  Bythen
//
//  Created by edisurata on 05/09/24.
//

import Foundation

class ByteSummaryViewModel: ObservableObject {
    
    @Published var profileInfo: String
    @Published var role: String
    @Published var xp: String
    @Published var memories: String
    @Published var knowledge: String
    @Published var dataPoints: [Double]
    @Published var dataLabels: [String]
    
    init(profileInfo: String, role: String, xp: String, memories: String, knowledge: String, dataPoints: [Double], dataLabels: [String]) {
        self.profileInfo = profileInfo != "" ? profileInfo : "-"
        self.role = role != "" ? role : "-"
        self.xp = xp != "" ? xp : "-"
        self.memories = memories != "" ? memories : "-"
        self.knowledge = knowledge != "" ? knowledge : "-"
        self.dataPoints = dataPoints
        self.dataLabels = dataLabels
    }
    
}
