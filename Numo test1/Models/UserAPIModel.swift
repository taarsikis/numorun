import Foundation
import Combine

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: IdentifiableError?

    @Published var user: User?
    
    func fetchUsers() {
        APIService.shared.getUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }

    func createUser(user: User) {
        APIService.shared.createUser(user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newUser):
                    self?.users.append(newUser)
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }

    
    func getUser(userId: String) {
        APIService.shared.getUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                    
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }

    
    func updateUser(userId: String, user: User, completion: @escaping (Result<User, Error>) -> Void) {
        APIService.shared.updateUser(userId: userId, user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let index = self?.users.firstIndex(where: { $0.id == userId }) {
                        self?.users[index] = user
                    }
                    completion(.success(user))  // Notify success
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                    completion(.failure(error))  // Notify failure
                }
            }
        }
    }


    func partialUpdateUser(userId: String, data: [String: Any], completion: @escaping () -> Void) {
        APIService.shared.partialUpdateUser(userId: userId, data: data) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser):
                    if let index = self?.users.firstIndex(where: { $0.id == userId }) {
                        self?.users[index] = updatedUser
                        completion()
                    }
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                    completion()
                }
            }
        }
    }
    
    func deleteUser(userId: String) {
        APIService.shared.deleteUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message)  // Print the success message
                    self?.users.removeAll { $0.id == userId }
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }
        }
    }
}
