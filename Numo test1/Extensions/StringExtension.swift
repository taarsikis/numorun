import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = TimeZone.current


        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension String {
    func validatePassword() -> Bool {
        let hasTwoDigits = self.range(of: "(.*\\d.*){2,}", options: .regularExpression) != nil
        let minLength = self.count >= 6

        if !minLength {
            return false
        } else if !hasTwoDigits {
            return false
        }
        
        return true
    }
}


