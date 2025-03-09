import SwiftUI
import Foundation

// MARK: - Trial Status
enum TrialStatus: Equatable {
    case active
    case expired
    case eligibleForTrial
}

// MARK: - Subscription Manager
@MainActor
final class SubscriptionManager: ObservableObject {
    // MARK: - Shared Instance
    static let shared: SubscriptionManager = .init()
    
    // MARK: - Published Properties
    @Published private(set) var isSubscribed: Bool = false
    @Published private(set) var trialStatus: TrialStatus = .expired
    
    // MARK: - Constants
    private let trialKey: String = "has_used_trial"
    private let trialStartDateKey: String = "trial_start_date"
    
    // MARK: - Initialization
    private init() {
        
        //checkTrialStatus()
        // For demo purposes, let's start with subscription active
        //isSubscribed = true
        PaywallHelper.shared.fetchProductPackages()
        PaywallHelper.shared.checkSubscriptionStatus { status in
            self.isSubscribed = status
        }
    }
    
    // MARK: - Trial Management
    private func checkTrialStatus() {
        let defaults: UserDefaults = .standard
        
        if defaults.bool(forKey: trialKey) {
            trialStatus = TrialStatus.expired
        } else {
            trialStatus = TrialStatus.eligibleForTrial
        }
        
        if let startDate: Date = defaults.object(forKey: trialStartDateKey) as? Date {
            let threeDaysAgo: Date = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            if startDate > threeDaysAgo {
                trialStatus = TrialStatus.active
            } else {
                trialStatus = TrialStatus.expired
            }
        }
    }
    
    func startTrial() {
        let defaults: UserDefaults = .standard
        defaults.set(true, forKey: trialKey)
        defaults.set(Date(), forKey: trialStartDateKey)
        trialStatus = TrialStatus.active
    }
    
    func activateSubscription() {
        trialStatus = TrialStatus.active
        //isSubscribed = true
    }
    
    func removeTrial() {
        let defaults: UserDefaults = .standard
        defaults.set(true, forKey: trialKey)
        defaults.removeObject(forKey: trialStartDateKey)
        trialStatus = TrialStatus.expired
    }
    
    func enableTrial() {
        let defaults: UserDefaults = .standard
        defaults.removeObject(forKey: trialKey)
        defaults.removeObject(forKey: trialStartDateKey)
        trialStatus = TrialStatus.eligibleForTrial
    }
}

// MARK: - Preview Helper
extension SubscriptionManager {
    static var preview: SubscriptionManager {
        let manager = SubscriptionManager.shared
        manager.trialStatus = TrialStatus.active
        return manager
    }
} 
