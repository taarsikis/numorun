import Foundation
import FirebaseFirestore

struct User: Identifiable {
    var id: String
    var email: String
    var name: String
    var dateOfBirth: Date
    var sex: String
    var weight: Double
    var experience: String
    var registrationStage: String

    init(id: String = "", dictionary: [String: Any]) {
        self.id = id
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.dateOfBirth = (dictionary["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
        self.sex = dictionary["sex"] as? String ?? ""
        self.weight = dictionary["weight"] as? Double ?? 0.0
        self.experience = dictionary["experience"] as? String ?? ""
        self.registrationStage = dictionary["registrationStage"] as? String ?? "name" // Default to first step if not set
    }
}
