import SwiftUI
import Firebase
import Combine

class UserData: ObservableObject {
    @Published var user: User?
    private var db = Firestore.firestore()
    @AppStorage("uid") var userID: String = ""

    func fetchUser(userId: String) {
        print("started fetching of userID: " + userId)
        let docRef = db.collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("document exists")
                let data = document.data() ?? [:]
                
                let user = User(id: document.documentID, dictionary: data)
                
                self.user = user
                DispatchQueue.main.async {
                    self.user = user
                }
            } else {
                print(error)
                print("Document does not exist")
            }
        }
    }
    
    func addUser(email: String, name: String, dateOfBirth: Date,sex: String, weight: Double, experience: String, registrationStage: String) {

        db.collection("users").document(userID).setData(["email": email, "name": name, "dateOfBirth": dateOfBirth, "weight": weight, "experience": experience, "registrationStage": registrationStage]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
        print("added user with id \(userID)")
    }
    
    func updateUser(data: [String: Any]) {
        db.collection("users").document(userID).updateData(data)
    }
}
