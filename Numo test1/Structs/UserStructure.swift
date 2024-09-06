import Foundation
import FirebaseFirestore

struct UserFb: Identifiable {
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
        if let weightValue = dictionary["weight"] {
            if let weightDouble = weightValue as? Double {
                self.weight = weightDouble
            } else if let weightString = weightValue as? String, let weightDouble = Double(weightString) {
                self.weight = weightDouble
            } else {
                self.weight = 0.0 // Default to 0.0 if the conversion fails
            }
        } else {
            self.weight = 0.0 // Default to 0.0 if `dictionary["weight"]` is nil
        }
        self.experience = dictionary["experience"] as? String ?? ""
        self.registrationStage = dictionary["registrationStage"] as? String ?? "name" // Default to first step if not set
    }
}
