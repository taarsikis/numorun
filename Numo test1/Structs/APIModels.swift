import Foundation

struct User: Codable, Identifiable {
    var id: String
    var email: String
    var name: String
    var sex: String
    var date_of_birth: String
    var weight: Int
    var experience: Int
    var balance: Int
}

struct Challenge: Codable, Identifiable {
    var id: Int?
    var name: String
    var description: String
    var price: Int
    var capacity: Int
    var slowest_pace: Int
    var creator: String
    var status: Int
}

struct ChallengeRun: Codable, Identifiable {
    var id: Int?
    var challenge_id: Int
    var date: String
    var distance_km: Int
}

struct Participant: Codable, Identifiable {
    var id: Int?
    var challenge_id: Int
    var user_id: String
    var user_status: Int
}

struct Run:  Codable, Identifiable {
    var id: Int
    var user_id: String
    var date: String  
    var timezone: String
    var distance: Double
    var duration: Double
    var pace: Double
    var city: String
}

struct ChallengeFinancials: Codable {
    let appEarnings: Int
    let winnerEarnings: Int
    
    enum CodingKeys: String, CodingKey {
        case appEarnings = "app_earnings"
        case winnerEarnings = "winner_earnings"
    }
}
