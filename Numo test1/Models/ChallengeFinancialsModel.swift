import Foundation
import Combine

class ChallengeFinancialsViewModel: ObservableObject {
    @Published var financials: ChallengeFinancials?
    @Published var errorMessage: String?

    // Method to fetch financial details from the API with a completion handler
    func fetchChallengeFinancials(challengeId: Int, completion: @escaping (Result<ChallengeFinancials, Error>) -> Void) {
        APIService.shared.getChallengeFinancials(challengeId: challengeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedFinancials):
                    self?.financials = fetchedFinancials
                    completion(.success(fetchedFinancials))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
