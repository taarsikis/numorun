import Foundation
import Combine

class ChallengeRunsViewModel: ObservableObject {
    @Published var challengeRuns: [ChallengeRun] = []
    @Published var errorMessage: String?

    
//    var averageDistance: Double {
//        let totalDistance = challengeRuns.reduce(0) { $0 + $1.distance_km }
//        return challengeRuns.isEmpty ? 0 : Double(totalDistance) / Double(challengeRuns.count)
//    }

//    var dateOfFirstRun: Date? {
//        guard let firstRun = challengeRuns.sorted(by: { $0.date < $1.date }).first else {
//            return nil
//        }
//        let dateFormatter = ISO8601DateFormatter()
//        return dateFormatter.date(from: firstRun.date)
//    }
    
    func getAverageDistanceAndFirstRunDate() -> (averageDistance: Double, firstRunDate: Date?) {
        let totalDistance = challengeRuns.reduce(0) { $0 + $1.distance_km }
        let averageDistance = challengeRuns.isEmpty ? 0 : Double(totalDistance) / Double(challengeRuns.count)
        
        let dateFormatter = ISO8601DateFormatter()
        let firstRunDate = challengeRuns.sorted(by: { $0.date < $1.date }).first.flatMap { dateFormatter.date(from: $0.date) }
        
        return (averageDistance, firstRunDate)
    }
    
    func fetchChallengeRuns() {
        APIService.shared.getChallengeRuns { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let challengeRuns):
                    self?.challengeRuns = challengeRuns
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func createChallengeRun(challengeRun: ChallengeRun) {
        APIService.shared.createChallengeRun(challengeRun: challengeRun) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newChallengeRun):
                    self?.challengeRuns.append(newChallengeRun)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteChallengeRun(challengeRunId: Int) {
        APIService.shared.deleteChallengeRun(challengeRunId: challengeRunId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.challengeRuns.removeAll { $0.id == challengeRunId }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchChallengeRunsByChallengeId(challengeId: Int, completion: @escaping () -> Void) {
        APIService.shared.getChallengeRunByChallenge(challengeId: challengeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let challengeRuns):
                    self?.challengeRuns = challengeRuns
                    completion()  // Notify that data is fetched and processed
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
}
