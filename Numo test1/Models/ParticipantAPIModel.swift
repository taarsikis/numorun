import Foundation
import Combine

class ParticipantsViewModel: ObservableObject {
    @Published var participants: [Participant] = []
    @Published var errorMessage: String?

    func fetchParticipants() {
        APIService.shared.getParticipants { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let participants):
                    self?.participants = participants
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func createParticipant(participant: Participant) {
        APIService.shared.createParticipant(participant: participant) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newParticipant):
                    self?.participants.append(newParticipant)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func updateParticipant(participantId: Int, participant: Participant) {
        APIService.shared.updateParticipant(participantId: participantId, participant: participant) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.participants.firstIndex(where: { $0.id == participantId }) {
                        self?.participants[index] = participant
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteParticipant(participantId: Int) {
        APIService.shared.deleteParticipant(participantId: participantId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.participants.removeAll { $0.id == participantId }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchParticipantsByChallengeId(challengeId: Int) {
        APIService.shared.getParticipantsByChallengeId(challengeId: challengeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let participants):
                    self?.participants = participants
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch participants for challenge ID \(challengeId): \(error.localizedDescription)"
                }
            }
        }
    }
    
}
