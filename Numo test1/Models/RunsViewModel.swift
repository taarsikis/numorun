import Foundation
import Combine

class RunsViewModel: ObservableObject {
    @Published var runs: [Run] = []
    @Published var errorMessage: String?

    private var cancellables: Set<AnyCancellable> = []

    // Fetch all runs from the API
    func fetchRuns() {
        APIService.shared.getRuns { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let runs):
                    self?.runs = runs
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch runs: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Create a new run
    func createRun(run: Run, completion: @escaping (Result<Run, Error>) -> Void) {
        APIService.shared.createRun(run: run) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newRun):
                    self?.runs.append(newRun)
                    completion(.success(newRun)) // Call the completion handler with success
                    print("Succes: created Run")
                case .failure(let error):
                    self?.errorMessage = "Failed to create run: \(error.localizedDescription)"
                    completion(.failure(error)) // Call the completion handler with failure
                }
            }
        }
    }

    
    // Get a specific run by ID
    func fetchRun(runId: Int) {
        APIService.shared.getRun(runId: runId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let run):
                    if let index = self?.runs.firstIndex(where: { $0.id == runId }) {
                        self?.runs[index] = run
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch run: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Delete a run
    func deleteRun(runId: Int) {
        APIService.shared.deleteRun(runId: runId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.runs.removeAll { $0.id == runId }
                case .failure(let error):
                    self?.errorMessage = "Failed to delete run: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Update a run
    func updateRun(runId: Int, run: Run) {
        APIService.shared.updateRun(runId: runId, run: run) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedRun):
                    if let index = self?.runs.firstIndex(where: { $0.id == runId }) {
                        self?.runs[index] = updatedRun
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to update run: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchRunsByUserId(userId: String) {
        APIService.shared.getRunsByUserId(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let runs):
                    self?.runs = runs
                    print("Runs loaded:", runs)
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch runs for user \(userId): \(error.localizedDescription)"
                    print("Error:", error.localizedDescription)
                }
            }
        }
    }

}
