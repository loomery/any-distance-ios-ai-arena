// Licensed under the Any Distance Source-Available License
//
//  MockMode.swift
//  ADAC
//
//  Created for development and testing purposes
//

import Foundation
import Combine
import CoreLocation

/// Manages mock mode state for DEBUG builds only.
/// When enabled, the app uses mock data instead of real API calls and HealthKit.
final class MockMode: ObservableObject {
    static let shared = MockMode()
    
    /// Whether mock mode is currently enabled
    @Published private(set) var isEnabled: Bool = false
    
    /// Check if mock mode is available (only in DEBUG builds)
    static var isAvailable: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    private init() {}
    
    /// Enables mock mode and sets up a demo user
    func enable() {
        #if DEBUG
        guard !isEnabled else { return }
        isEnabled = true
        setupMockUser()
        print("🎭 Mock Mode enabled")
        #endif
    }
    
    /// Disables mock mode
    func disable() {
        #if DEBUG
        isEnabled = false
        print("🎭 Mock Mode disabled")
        #endif
    }
    
    /// Sets up a mock user with demo data
    private func setupMockUser() {
        let mockUser = ADUser()
        mockUser.id = "mock_user_\(UUID().uuidString.prefix(8))"
        mockUser.appleSignInID = "mock_apple_id_\(UUID().uuidString.prefix(8))"
        mockUser.name = "Demo User"
        mockUser.email = "demo@anydistance.app"
        mockUser.username = "demo_runner"
        mockUser.phoneNumber = "+15555555555"
        mockUser.distanceUnit = .miles
        mockUser.signupDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
        mockUser.bio = "🏃 Demo account for testing Any Distance"
        mockUser.totalDistanceTrackedMeters = 250_000 // ~155 miles
        mockUser.totalTimeTracked = 72_000 // 20 hours
        mockUser.collectibles = MockDataProvider.mockCollectibles
        mockUser.goals = MockDataProvider.mockGoals
        mockUser.recentActivityTypes = [.run, .walk, .bikeRide]
        mockUser.coverPhotoUrl = S3.randomCoverPhotoURL()
        
        ADUser.current = mockUser
        ADUser.current.hasFinishedOnboarding = true
        
        // Cache mock activities
        MockDataProvider.loadMockActivities()
    }
}

// MARK: - Mock Data Provider

/// Provides mock data for testing and demo purposes
struct MockDataProvider {
    
    // MARK: - Mock Activities
    
    static func loadMockActivities() {
        let activities = mockActivities
        ActivitiesData.shared.cacheActivities(activities: activities)
    }
    
    static var mockActivities: [Activity] {
        var activities: [Activity] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Create a variety of activities over the past 30 days
        let activityTemplates: [(ActivityType, Float, TimeInterval)] = [
            (.run, 5000, 1800),           // 5K run, 30 min
            (.run, 10000, 3600),          // 10K run, 60 min
            (.walk, 3000, 2400),          // 3K walk, 40 min
            (.bikeRide, 15000, 2700),     // 15K bike, 45 min
            (.run, 3200, 1200),           // 2 mile run, 20 min
            (.hike, 8000, 7200),          // 8K hike, 2 hours
            (.yoga, 0, 3600),             // Yoga, 1 hour
            (.swimming, 1500, 2400),      // 1.5K swim, 40 min
        ]
        
        for dayOffset in 0..<30 {
            // Not every day has an activity
            guard dayOffset % 2 == 0 || dayOffset < 7 else { continue }
            
            let template = activityTemplates[dayOffset % activityTemplates.count]
            let activityDate = calendar.date(byAdding: .day, value: -dayOffset, to: now) ?? now
            let startTime = calendar.date(bySettingHour: 7 + (dayOffset % 12), minute: 30, second: 0, of: activityDate) ?? activityDate
            
            let activity = MockActivity(
                id: "mock_activity_\(dayOffset)",
                activityType: template.0,
                distance: template.1 + Float.random(in: -500...500),
                movingTime: template.2 + TimeInterval.random(in: -300...300),
                startDate: startTime,
                activeCalories: Float.random(in: 200...600),
                totalElevationGain: Float.random(in: 0...200)
            )
            activities.append(activity)
        }
        
        return activities
    }
    
    // MARK: - Mock Collectibles
    
    static var mockCollectibles: [Collectible] {
        let now = Date()
        return [
            Collectible(type: .activity(.mi_1), dateEarned: now.addingTimeInterval(-86400 * 30)),
            Collectible(type: .activity(.k_5), dateEarned: now.addingTimeInterval(-86400 * 20)),
            Collectible(type: .activity(.mi_10), dateEarned: now.addingTimeInterval(-86400 * 10)),
            Collectible(type: .special(.beta), dateEarned: now.addingTimeInterval(-86400 * 60)),
            Collectible(type: .special(.day1), dateEarned: now.addingTimeInterval(-86400 * 90)),
        ]
    }
    
    // MARK: - Mock Goals
    
    static var mockGoals: [Goal] {
        let now = Date()
        let calendar = Calendar.current
        
        let goal1 = Goal(
            startDate: calendar.date(byAdding: .day, value: -21, to: now) ?? now,
            endDate: calendar.date(byAdding: .day, value: 7, to: now) ?? now,
            activityType: .run,
            distanceMeters: 50_000,
            unit: .miles
        )
        goal1.currentDistanceMeters = 35_000
        
        let goal2 = Goal(
            startDate: now,
            endDate: calendar.date(byAdding: .month, value: 1, to: now) ?? now,
            activityType: .bikeRide,
            distanceMeters: 200_000,
            unit: .miles
        )
        goal2.currentDistanceMeters = 80_000
        
        return [goal1, goal2]
    }
    
    // MARK: - Mock Friends
    
    static var mockFriends: [ADUser] {
        let friend1 = ADUser()
        friend1.id = "mock_friend_1"
        friend1.name = "Alex Runner"
        friend1.username = "alex_runs"
        friend1.bio = "Marathon enthusiast 🏃‍♂️"
        friend1.totalDistanceTrackedMeters = 500_000
        
        let friend2 = ADUser()
        friend2.id = "mock_friend_2"
        friend2.name = "Sam Cyclist"
        friend2.username = "sam_cycles"
        friend2.bio = "Weekend warrior on two wheels 🚴"
        friend2.totalDistanceTrackedMeters = 800_000
        
        let friend3 = ADUser()
        friend3.id = "mock_friend_3"
        friend3.name = "Jordan Hiker"
        friend3.username = "jordan_hikes"
        friend3.bio = "Mountain lover ⛰️"
        friend3.totalDistanceTrackedMeters = 300_000
        
        return [friend1, friend2, friend3]
    }
}

// MARK: - Mock Activity

/// A concrete implementation of Activity for mock data
struct MockActivity: Activity, Codable {
    let id: String
    let activityType: ActivityType
    let distance: Float
    let movingTime: TimeInterval
    let startDate: Date
    let activeCalories: Float
    let totalElevationGain: Float
    
    var startDateLocal: Date { startDate }
    var endDate: Date { startDate.addingTimeInterval(movingTime) }
    var endDateLocal: Date { endDate }
    var stepCount: Int? { activityType == .run || activityType == .walk ? Int(distance / 0.75) : nil }
    var workoutSource: HealthKitWorkoutSource? { .anyDistance }
    var clipsRoute: Bool { false }
    
    var coordinates: [CLLocation] {
        get async throws {
            // Return empty for mock - could be enhanced with sample route data
            return []
        }
    }
    
    var splits: [Split] {
        get async throws {
            // Generate mock splits based on distance
            guard distance > 0, activityType.isDistanceBased else { return [] }
            
            let unit: DistanceUnit = ADUser.current.distanceUnit
            let unitDistanceMeters: Double = unit == .miles ? 1609.34 : 1000.0
            let numSplits = Int(Double(distance) / unitDistanceMeters)
            guard numSplits > 0 else { return [] }
            
            var splits: [Split] = []
            let avgPacePerSplit = movingTime / Double(numSplits)
            var currentStartDate = startDate
            
            for i in 0..<numSplits {
                let variance = TimeInterval.random(in: -30...30)
                let splitDuration = avgPacePerSplit + variance
                let startDistanceMeters = Double(i) * unitDistanceMeters
                let totalDistanceMeters = Double(i + 1) * unitDistanceMeters
                
                let split = Split(
                    unit: unit,
                    startDate: currentStartDate,
                    duration: splitDuration,
                    startDistanceMeters: startDistanceMeters,
                    totalDistanceMeters: totalDistanceMeters,
                    isPartial: false
                )
                splits.append(split)
                currentStartDate = currentStartDate.addingTimeInterval(splitDuration)
            }
            
            return splits
        }
    }
}
