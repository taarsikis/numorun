import Foundation

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
