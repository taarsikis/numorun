import Foundation
import Combine

struct FetchedChallenge: Identifiable {
    var id : Int?
    var challenge : Challenge
    var challengeRuns : [ChallengeRun]
    var averageDistance : Int
    var startDate : Date?
    var financials : ChallengeFinancials?
}

class ChallengesViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var errorMessage: String?
    @Published var challenge: Challenge?

    func fetchChallenges() {
        APIService.shared.getChallenges { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let challenges):
                    self?.challenges = challenges
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadUserChallenges(userId : String) {
        
        APIService.shared.getUserChallenges(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let challenges):
                    print("Loaded challenges for user ( \(userId) ):", challenges)
                    self.challenges = challenges
                case .failure(let error):
                    print("Error loading challenges:", error.localizedDescription)
                    
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func createChallengeWithRuns(challenge: Challenge, runningDays: [RunningDay], completion: @escaping (Result<Challenge, Error>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate] // Ensuring the date format is "YYYY-MM-DD"
        
        let challengeRuns = runningDays.map { runningDay in
            let dateString = dateFormatter.string(from: runningDay.date)
            return ChallengeRun(id: nil, challenge_id: challenge.id ?? 0, date: dateString, distance_km: runningDay.kilometers)
        }

        let challengeWithRuns = ChallengeWithRuns(challenge: challenge, challenge_runs: challengeRuns)
        
        APIService.shared.createChallengeWithRuns(challengeWithRuns: challengeWithRuns) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newChallengeWithRuns):
                    self?.challenges.append(newChallengeWithRuns.challenge)
                    self?.challenge = newChallengeWithRuns.challenge
                    completion(.success(newChallengeWithRuns.challenge))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }



    func updateChallenge(challengeId: Int, challenge: Challenge) {
        APIService.shared.updateChallenge(challengeId: challengeId, challenge: challenge) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.challenges.firstIndex(where: { $0.id == challengeId }) {
                        self?.challenges[index] = challenge
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteChallenge(challengeId: Int) {
        APIService.shared.deleteChallenge(challengeId: challengeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.challenges.removeAll { $0.id == challengeId }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
