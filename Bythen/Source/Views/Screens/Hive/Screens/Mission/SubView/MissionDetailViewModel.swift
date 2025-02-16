//
//  MissionDetailViewModel.swift
//  Bythen
//
//  Created by Darul Firmansyah on 08/01/25.
//

import Foundation
import SwiftUI

final class MissionDetailViewModel: BaseViewModel {
    let missionId: Int
    let imageURLString: String
    let content: AttributedString
    let earnedNectar: Int
    let earnedNectarDesc: String
    let objectiveTitle: String
    let isCompleted: Bool
    let postId: String
    @Published
    var missionCountdown: Int
    @Published
    var buttonState: MissionButtonsState
    @Published
    var missionObjective: [MissionObjectiveViewModel]
    @Published
    var objectiveIncompleteCount: Int
    var timer: Timer?
    
    var onTimerElapsed: ((Int) -> Void)?
    
    init(with mission: Mission, onTimerElapsed: ((Int) -> Void)?) {
        self.missionId = mission.id
        self.postId = mission.postId
        self.imageURLString = mission.imageURLString
        
        self.content = Self.attributedContent(content: mission.content)
        self.earnedNectar = mission.earnedNectar
        self.earnedNectarDesc = mission.earnedNectar.description + " " + "NECTAR"
        self.objectiveTitle = "Objectives".uppercased() + " " + "(\(mission.countObjectiveFinished)/\(mission.objectives.count))"
        self.isCompleted = mission.countObjectiveFinished == mission.objectives.count
        
        self.buttonState = mission.countObjectiveFinished == mission.objectives.count ? .hidden : .active
        self.missionObjective = mission.objectives.map({ MissionObjectiveViewModel(with: $0) })
        if !isCompleted {
            self.missionCountdown = mission.missionCountdown ?? 0
        }
        else {
            self.missionCountdown = 0
        }
        self.objectiveIncompleteCount = mission.objectives.map({ MissionObjectiveViewModel(with: $0) }).filter({ $0.state == .incomplete }).count
        self.onTimerElapsed = onTimerElapsed
        super.init()
        
        startTimerIfNeeded()
    }
    
    func startTimerIfNeeded() {
        guard missionCountdown > 0 else { return }
        
        timer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.missionCountdown > 1 {
                self.missionCountdown -= 1
            } else {
                onTimerElapsed?(missionId)
                self.stopTimer()
            }
        }
        
        // avoid timer stop during scroll
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        self.timer = timer
    }
    
    deinit {
        stopTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct MissionObjectiveViewModel: Identifiable, Hashable {
    let id: Int
    let missionId: Int
    let objectiveTitle: String
    let iconURLString: String?
    let finishedAt: String?
    let defaultImageName: String
    
    var state: MissionProgressState
    
    init(with objective: MissionObjective) {
        self.id = objective.id
        self.missionId = objective.missionId
        self.objectiveTitle = objective.objective
        
        self.iconURLString = objective.iconURLString
        defaultImageName = objective.objectiveType.imageName
        
        
        self.finishedAt = objective.finishedAt
        
        if let status = objective.status {
            if status.lowercased() == "pending" {
                self.state = .verifying
            }
            else if status.lowercased() == "verified" {
                self.state = .completed
            }
            else {
                self.state = .incomplete
            }
        }
        else {
            self.state = .notStarted
        }
    }
}

enum MissionButtonsState: Codable {
    case active
    case verifying
    case hidden
    
    var enabled: Bool {
        self == .active
    }
    
    var verifyButtonColor: Color {
        self == .active ? Color.sonicBlue700 : Color.ghostWhite200
    }
    
    var verifyButtonTitleColor: Color {
        self == .active ? Color.white : Color.ghostWhite400
    }
}

enum MissionProgressState: Codable {
    case notStarted
    case verifying
    case completed
    case incomplete
}


extension MissionDetailViewModel {
    static func attributedContent(content: String) -> AttributedString {
        var attributedContent = AttributedString(content)
        
        // Regular expression to match @mentions and #hashtags
        let pattern = "(?:\\r?\\n)?[@#]\\w+(?:\\r?\\n)?"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
            
            for match in matches {
                if let range = Range(match.range, in: attributedContent) {
                    attributedContent[range].foregroundColor = .sonicBlue500
                }
            }
        } catch {
            print("Error creating regex: \(error)")
        }
        return attributedContent
    }
}
