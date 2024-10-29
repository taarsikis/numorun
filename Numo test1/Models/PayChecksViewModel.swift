import Foundation
import Combine

class PaychecksViewModel: ObservableObject {
    @Published var paycheck: PaycheckCreate = PaycheckCreate(userID: "", amount: 0.0, message: "", invoiceId: "", paymentUrl: "")
    @Published var paychecks : [PayCheck] = []
    @Published var errorMessage: String?

    
    func fetchPayChecks(completion: @escaping (Result<[PayCheck], Error>) -> Void ){
        APIService.shared.getSuccessPaychecks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let paychecks):
                    self?.paychecks = paychecks
                    completion(.success(paychecks))
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch runs: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Function to create a paycheck
    func createPaycheck(paycheck: PaycheckCreate, completion: @escaping (Result<PaycheckCreate, Error>) -> Void) {

        APIService.shared.createPaycheck(paycheck: paycheck) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newPaycheck):
                    self?.paycheck = newPaycheck
                    completion(.success(newPaycheck)) // Notify success
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error)) // Notify failure
                }
            }
        }
    }


}
