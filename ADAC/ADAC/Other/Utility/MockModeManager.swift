#if DEBUG

import Foundation
import CoreLocation
import HealthKit
import UIKit

struct MockActivity: Activity {
    let id: String
    let activityType: ActivityType
    let distance: Float
    let movingTime: TimeInterval
    let startDate: Date
    let endDate: Date
    let coordinatePoints: [CLLocation]
    let splitPoints: [Split]
    let stepCount: Int?
    let activeCalories: Float
    let totalElevationGain: Float
    let source: HealthKitWorkoutSource?

    var startDateLocal: Date { startDate }
    var endDateLocal: Date { endDate }
    var clipsRoute: Bool { false }
    var workoutSource: HealthKitWorkoutSource? { source }
    var sortDate: Date { startDate }

    var coordinates: [CLLocation] {
        get async throws { coordinatePoints }
    }

    var splits: [Split] {
        get async throws { splitPoints }
    }
}

struct MockFriendFinderSnapshot {
    let contactsOnAD: [FriendFinderUser]
    let contactsNotOnAD: [FriendFinderUser]
    let leaderboard: [FriendFinderAPI.LeaderboardItem]
}

final class MockModeManager {
    static let shared = MockModeManager()

    private let storageKey = "com.anydistance.mockmode.enabled"
    private(set) var isEnabled: Bool

    private var demoUser: ADUser = ADUser()
    private(set) var activities: [Activity] = []
    private(set) var posts: [Post] = []
    private(set) var clubStats: ClubStatsData
    private(set) var pastStats: [DateRangedClubStatsData]
    private(set) var snapshot: MockFriendFinderSnapshot

    private init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: storageKey)
        let data = DemoDataFactory.make()
        self.demoUser = data.user
        self.activities = data.activities
        self.posts = data.posts
        self.clubStats = data.clubStats
        self.pastStats = data.pastStats
        self.snapshot = data.friendFinderSnapshot

        if isEnabled {
            bootstrapState()
        }
    }

    func resumeIfNeeded() {
        if isEnabled {
            bootstrapState()
        }
    }

    func enableDemoExperience() {
        guard !isEnabled else {
            UIApplication.shared.transitionToTabBar()
            return
        }

        isEnabled = true
        UserDefaults.standard.set(true, forKey: storageKey)
        bootstrapState()
        UIApplication.shared.transitionToTabBar()
    }

    func ensureCachesPrimed() {
        if isEnabled {
            bootstrapState()
        }
    }

    func friendPosts() -> [Post] {
        return posts
    }

    func add(post: Post) {
        posts.removeAll(where: { $0.id == post.id })
        posts.append(post)
        posts.sort(by: { $0.creationDate > $1.creationDate })
        PostCache.shared.cache(post: post, sendCachedPublisher: true)
    }

    func clubStatsData() -> ClubStatsData {
        return clubStats
    }
    
    func remove(postID: String) {
        posts.removeAll(where: { $0.id == postID })
        if let cachedPost = PostCache.shared.post(withID: postID) {
            PostCache.shared.delete(post: cachedPost, sendCachedPublisher: true)
        }
    }

    func historicalClubStats() -> [DateRangedClubStatsData] {
        return pastStats
    }

    func friendFinderData() -> MockFriendFinderSnapshot {
        return snapshot
    }

    func applyDemoUser() {
        bootstrapState()
    }

    private func bootstrapState() {
        let cloned = demoUser.deepCopy()
        ADUser.current = cloned
        ADUser.current.hasFinishedOnboarding = true
        NSUbiquitousKeyValueStore.default.currentUser = cloned
        NSUbiquitousKeyValueStore.default.usersOnAD = snapshot.contactsOnAD.compactMap { $0.adUser }
        NSUbiquitousKeyValueStore.default.leaderboard = snapshot.leaderboard
        UserDefaults.standard.hasAskedForHealthKitReadPermission = true
        UserDefaults.standard.hasAskedForHealthKitRingsPermission = true
        ActivitiesData.shared.applyMockActivities(activities)
        cachePosts()
        ClubStatsCache.shared.cache(clubStats: clubStats, for: PostManager.shared.thisWeekPostStartDate)
    }

    private func cachePosts() {
        for post in posts {
            PostCache.shared.cache(post: post, sendCachedPublisher: false)
        }
        PostCache.shared.postCachedPublisher.send()
    }
}

private enum DemoDataFactory {
    static func make() -> (user: ADUser,
                           activities: [Activity],
                           posts: [Post],
                           clubStats: ClubStatsData,
                           pastStats: [DateRangedClubStatsData],
                           friendFinderSnapshot: MockFriendFinderSnapshot) {
        let baseDate = Date()
        let run = makeActivity(id: "mock-run",
                               type: .run,
                               distanceMeters: 6500,
                               duration: 1800,
                               start: baseDate.addingTimeInterval(-7200),
                               elevationGain: 40,
                               calories: 420,
                               stepCount: 7200)
        let walk = makeActivity(id: "mock-walk",
                                type: .walk,
                                distanceMeters: 3200,
                                duration: 2400,
                                start: baseDate.addingTimeInterval(-14400),
                                elevationGain: 10,
                                calories: 200,
                                stepCount: 5600)
        let ride = makeActivity(id: "mock-ride",
                                type: .bikeRide,
                                distanceMeters: 18000,
                                duration: 3600,
                                start: baseDate.addingTimeInterval(-21600),
                                elevationGain: 120,
                                calories: 900,
                                stepCount: nil)

        let currentUser = makeUser(id: "demo-user",
                                   name: "Casey Demo",
                                   username: "casedemo",
                                   friends: ["mock-friend-1", "mock-friend-2"],
                                   collectibles: makeCollectibles(),
                                   goals: makeGoals())

        let friendA = makeFriend(id: "mock-friend-1", name: "Sky Mora", username: "skym")
        let friendB = makeFriend(id: "mock-friend-2", name: "Riyu Han", username: "riyuhan")
        UserCache.shared.cache(user: friendA)
        UserCache.shared.cache(user: friendB)

        let post1 = makePost(id: "demo-post-1",
                              author: currentUser,
                              activity: run,
                              title: "Golden Hour Miles",
                              body: "Closed out the day with relaxed sunset miles.")
        let post2 = makePost(id: "demo-post-2",
                              author: friendA,
                              activity: ride,
                              title: "City Loop",
                              body: "Fast group ride with the club this morning.")
        let post3 = makePost(id: "demo-post-3",
                              author: friendB,
                              activity: walk,
                              title: "Coffee Walk",
                              body: "Stretching the legs before diving into work.")

        let clubStats = ClubStatsData(postCount: 9,
                                      totalDistanceMeters: 72000,
                                      totalMovingTime: 12480,
                                      totalActiveCals: 2300,
                                      totalElevGainMeters: 380,
                                      collectibleRawValues: ["activity_k_10", "activity_mi_30", "totaldistance_mi_500"])

        let pastStats = makePastStats()

        let snapshot = MockFriendFinderSnapshot(contactsOnAD: makeFriendFinderUsers(from: [friendA, friendB]),
                                                contactsNotOnAD: makeInvitees(),
                                                leaderboard: makeLeaderboard())

        return (currentUser, [run, walk, ride], [post1, post2, post3], clubStats, pastStats, snapshot)
    }

    private static func makeActivity(id: String,
                                     type: ActivityType,
                                     distanceMeters: Float,
                                     duration: TimeInterval,
                                     start: Date,
                                     elevationGain: Float,
                                     calories: Float,
                                     stepCount: Int?) -> Activity {
        let end = start.addingTimeInterval(duration)
        let coords = stride(from: 0, through: 10, by: 1).map { idx -> CLLocation in
            let delta = Double(idx) * 0.0008
            return CLLocation(latitude: 33.777 + delta,
                              longitude: -84.388 + (delta / 2.0))
        }
        let split = Split(unit: .miles,
                          startDate: start,
                          duration: duration / 2.0,
                          startDistanceMeters: 0,
                          totalDistanceMeters: Double(distanceMeters) / 2.0,
                          isPartial: false)
        return MockActivity(id: id,
                            activityType: type,
                            distance: distanceMeters,
                            movingTime: duration,
                            startDate: start,
                            endDate: end,
                            coordinatePoints: coords,
                            splitPoints: [split],
                            stepCount: stepCount,
                            activeCalories: calories,
                            totalElevationGain: elevationGain,
                            source: .anyDistance)
    }

    private static func makeCollectibles() -> [Collectible] {
        return [
            Collectible(type: .activity(.k_5), dateEarned: Date().addingTimeInterval(-86400 * 5)),
            Collectible(type: .activity(.k_10), dateEarned: Date().addingTimeInterval(-86400 * 9)),
            Collectible(type: .totalDistance(.mi_100), dateEarned: Date().addingTimeInterval(-86400 * 30))
        ]
    }

    private static func makeGoals() -> [Goal] {
        let goal = Goal(startDate: Date().addingTimeInterval(-86400 * 3),
                        endDate: Date().addingTimeInterval(86400 * 4),
                        activityType: .run,
                        distanceMeters: UnitConverter.value(25, inUnitToMeters: .miles),
                        unit: .miles)
        goal.currentDistanceMeters = UnitConverter.value(18, inUnitToMeters: .miles)
        return [goal]
    }

    private static func makeUser(id: String,
                                 name: String,
                                 username: String,
                                 friends: [String],
                                 collectibles: [Collectible],
                                 goals: [Goal]) -> ADUser {
        let user = ADUser()
        user.id = id
        user.appleSignInID = "apple-\(id)"
        user.name = name
        user.email = "\(username)@example.com"
        user.username = username
        user.phoneNumber = "+15555550123"
        user.distanceUnit = .miles
        user.friendIDs = friends
        user.friendships = friends.map {
            Friendship(id: UUID().uuidString,
                       requestingUserID: user.id,
                       targetUserID: $0,
                       approvedAt: UInt64(Date().timeIntervalSince1970))
        }
        user.collectibles = collectibles
        user.goals = goals
        user.totalDistanceTrackedMeters = 250000
        user.totalTimeTracked = 3600 * 210
        user.location = "Atlanta, GA"
        user.signupDate = Date().addingTimeInterval(-86400 * 120)
        user.coverPhotoUrl = URL(string: "https://example.com/demo-cover.jpg")
        user.profilePhotoUrl = URL(string: "https://example.com/demo-profile.jpg")
        return user
    }

    private static func makeFriend(id: String,
                                   name: String,
                                   username: String) -> ADUser {
        let user = ADUser()
        user.id = id
        user.appleSignInID = "apple-\(id)"
        user.name = name
        user.username = username
        user.email = "\(username)@example.com"
        user.distanceUnit = .miles
        user.signupDate = Date().addingTimeInterval(-86400 * 260)
        return user
    }

    private static func makePost(id: String,
                                  author: ADUser,
                                  activity: Activity,
                                  title: String,
                                  body: String) -> Post {
        let post = Post(localActivity: activity)
        post.id = id
        post.creatorUserID = author.id
        post.title = title
        post.postDescription = body
        post.creationDate = activity.endDate
        post.collectibleRawValues = ["activity_k_5"]
        post.reactions = []
        post.comments = []
        return post
    }

    private static func makeFriendFinderUsers(from users: [ADUser]) -> [FriendFinderUser] {
        return users.map { user in
            FriendFinderUser(adUser: user,
                             name: user.name,
                             phoneNumber: "+14045550111",
                             contactProfilePhoto: nil,
                             isInContacts: true,
                             friendState: .notAdded,
                             contactCount: Int.random(in: 1...6))
        }
    }

    private static func makeInvitees() -> [FriendFinderUser] {
        return [
            FriendFinderUser(adUser: nil,
                             name: "Dev Patel",
                             phoneNumber: "+14045558001",
                             contactProfilePhoto: nil,
                             isInContacts: true,
                             friendState: .notInvited,
                             contactCount: 3),
            FriendFinderUser(adUser: nil,
                             name: "June Park",
                             phoneNumber: "+14045558025",
                             contactProfilePhoto: nil,
                             isInContacts: true,
                             friendState: .notInvited,
                             contactCount: 1)
        ]
    }

    private static func makeLeaderboard() -> [FriendFinderAPI.LeaderboardItem] {
        return [
            FriendFinderAPI.LeaderboardItem(hashedPhone: "hash_a",
                                            unhashedPhone: "+15555558888",
                                            count: 4),
            FriendFinderAPI.LeaderboardItem(hashedPhone: "hash_b",
                                            unhashedPhone: "+15555557777",
                                            count: 2)
        ]
    }

    private static func makePastStats() -> [DateRangedClubStatsData] {
        var stats: [DateRangedClubStatsData] = []
        for idx in 1...3 {
            let start = Calendar.current.date(byAdding: .weekOfYear, value: -idx, to: Date()) ?? Date()
            let end = Calendar.current.date(byAdding: .day, value: 7, to: start) ?? start
            let data = ClubStatsData(postCount: 6 + idx,
                                     totalDistanceMeters: Float(40000 + (idx * 5000)),
                                     totalMovingTime: Float(10000 + (idx * 1200)),
                                     totalActiveCals: Float(1500 + (idx * 250)),
                                     totalElevGainMeters: Float(200 + (idx * 30)),
                                     collectibleRawValues: ["activity_k_10"])
            stats.append(DateRangedClubStatsData(startDate: start, endDate: end, data: data))
        }
        return stats
    }
}

private extension ADUser {
    func deepCopy() -> ADUser {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let copy = try? JSONDecoder().decode(ADUser.self, from: data) else {
            return self
        }
        return copy
    }
}

#endif
