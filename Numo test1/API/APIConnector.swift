import Foundation

struct APIMessageResponse: Codable {
    let message: String
}


struct ChallengeWithRuns: Codable {
    var challenge: Challenge
    var challenge_runs: [ChallengeRun]
}

let semaphore = DispatchSemaphore(value: 0)

class APIService {
    static let shared = APIService()
    private let baseURL = "https://numoapi.work"
    
    private func request<T: Codable>(_ endpoint: String, method: String = "GET", body: T? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            print("Error: Invalid URL - \(baseURL)\(endpoint)")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        print("Request URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "Encoding Error")")
            } catch {
                print("Error: Failed to encode request body - \(error)")
                completion(.failure(error))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: Network error - \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error: HTTP error - Status Code \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Decoding Error")")
            
            do {
                if T.self == APIMessageResponse.self {
                    let decodedResponse = try JSONDecoder().decode(APIMessageResponse.self, from: data)
                    completion(.success(decodedResponse as! T))
                } else {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                }
            } catch {
                print("Error: Failed to decode response - \(error)")
                completion(.failure(error))
            }
            
            
        }.resume()
        semaphore.signal()
    }
    
    // Challenge with Runs Endpoint
    func createChallengeWithRuns(challengeWithRuns: ChallengeWithRuns, completion: @escaping (Result<ChallengeWithRuns, Error>) -> Void) {
        request("/challenges-with-runs", method: "POST", body: challengeWithRuns, completion: completion)
    }
    
    // User Endpoints
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        request("/users", completion: completion)
    }
    
    func createUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        request("/users", method: "POST", body: user, completion: completion)
    }
    
    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        request("/users/\(userId)", completion: completion)
    }
    
    func updateUser(userId: String, user: User, completion: @escaping (Result<User, Error>) -> Void) {
        request("/users/\(userId)", method: "PUT", body: user, completion: completion)
    }
    
    func deleteUser(userId: String, completion: @escaping (Result<APIMessageResponse, Error>) -> Void) {
        request("/users/\(userId)", method: "DELETE", completion: completion)
    }
    
    func partialUpdateUser(userId: String, data: [String: Any], completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userId)") else {
            print("Error: Invalid URL - \(baseURL)/users/\(userId)")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        print("Request URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "Encoding Error")")
        } catch {
            print("Error: Failed to encode request body - \(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Network error - \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            print("Response Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data {
                    let responseBody = String(data: data, encoding: .utf8) ?? "Unable to parse response body"
                    print("Response Body: \(responseBody)")
                }
                print("Error: HTTP error - Status Code \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Decoding Error")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(User.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Error: Failed to decode response - \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func getUserChallenges(userId: String, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        request("/users/\(userId)/challenges", completion: completion)
    }
    
    func getChallenges(completion: @escaping (Result<[Challenge], Error>) -> Void) {
        request("/challenges", completion: completion)
    }
    
    func createChallenge(challenge: Challenge, completion: @escaping (Result<Challenge, Error>) -> Void) {
        request("/challenges", method: "POST", body: challenge, completion: completion)
    }
    
    func getChallenge(challengeId: Int, completion: @escaping (Result<Challenge, Error>) -> Void) {
        request("/challenges/\(challengeId)", completion: completion)
    }
    
    func updateChallenge(challengeId: Int, challenge: Challenge, completion: @escaping (Result<Challenge, Error>) -> Void) {
        request("/challenges/\(challengeId)", method: "PUT", body: challenge, completion: completion)
    }
    
    func deleteChallenge(challengeId: Int, completion: @escaping (Result<APIMessageResponse, Error>) -> Void) {
        request("/challenges/\(challengeId)", method: "DELETE", completion: completion)
    }
    
    // Challenge Run Endpoints
    func getChallengeRuns(completion: @escaping (Result<[ChallengeRun], Error>) -> Void) {
        request("/challenge-runs", completion: completion)
    }
    
    func createChallengeRun(challengeRun: ChallengeRun, completion: @escaping (Result<ChallengeRun, Error>) -> Void) {
        request("/challenge-runs", method: "POST", body: challengeRun, completion: completion)
    }
    
    func getChallengeRun(challengeRunId: Int, completion: @escaping (Result<ChallengeRun, Error>) -> Void) {
        request("/challenge-runs/\(challengeRunId)", completion: completion)
    }
    
    func getChallengeRunByChallenge(challengeId: Int, completion: @escaping (Result<[ChallengeRun], Error>) -> Void) {
        request("/challenges/\(challengeId)/runs", completion: completion)
        
    }
    
    func deleteChallengeRun(challengeRunId: Int, completion: @escaping (Result<APIMessageResponse, Error>) -> Void) {
        request("/challenge-runs/\(challengeRunId)", method: "DELETE", completion: completion)
    }
    
    // Participant Endpoints
    func getParticipants(completion: @escaping (Result<[Participant], Error>) -> Void) {
        request("/participants", completion: completion)
    }
    
    func createParticipant(participant: Participant, completion: @escaping (Result<Participant, Error>) -> Void) {
        request("/participants", method: "POST", body: participant, completion: completion)
    }
    
    func getParticipant(participantId: Int, completion: @escaping (Result<Participant, Error>) -> Void) {
        request("/participants/\(participantId)", completion: completion)
    }
    
    func updateParticipant(participantId: Int, participant: Participant, completion: @escaping (Result<Participant, Error>) -> Void) {
        request("/participants/\(participantId)", method: "PUT", body: participant, completion: completion)
    }
    
    func deleteParticipant(participantId: Int, completion: @escaping (Result<APIMessageResponse, Error>) -> Void) {
        request("/participants/\(participantId)", method: "DELETE", completion: completion)
    }
    
    func getParticipantsByChallengeId(challengeId: Int, completion: @escaping (Result<[Participant], Error>) -> Void) {
        request("/challenges/\(challengeId)/participants", completion: completion)
    }
    
    func getRuns(completion: @escaping (Result<[Run], Error>) -> Void) {
            request("/runs", completion: completion)
        }
        
        // Create a new run
        func createRun(run: Run, completion: @escaping (Result<Run, Error>) -> Void) {
            request("/runs", method: "POST", body: run, completion: completion)
        }
        
        // Get specific run by ID
        func getRun(runId: Int, completion: @escaping (Result<Run, Error>) -> Void) {
            request("/runs/\(runId)", completion: completion)
        }
        
        // Delete a run
        func deleteRun(runId: Int, completion: @escaping (Result<APIMessageResponse, Error>) -> Void) {
            request("/runs/\(runId)", method: "DELETE", completion: completion)
        }

        // Update a run
        func updateRun(runId: Int, run: Run, completion: @escaping (Result<Run, Error>) -> Void) {
            request("/runs/\(runId)", method: "PUT", body: run, completion: completion)
        }
    
    func getRunsByUserId(userId: String, completion: @escaping (Result<[Run], Error>) -> Void) {
            request("/users/\(userId)/runs", completion: completion)
        }
    
    func getChallengeFinancials(challengeId: Int, completion: @escaping (Result<ChallengeFinancials, Error>) -> Void) {
        request("/challenges/\(challengeId)/financials", completion: completion)
    }

    func createPaycheck(paycheck: PaycheckCreate, completion: @escaping (Result<PaycheckCreate, Error>) -> Void) {
        request("/create_paycheck/", method: "POST", body: paycheck, completion: completion)
    }

    func getSuccessPaychecks(completion: @escaping (Result<[PayCheck], Error>) -> Void) {
        request("/paychecks/success", completion: completion)
    }
}

