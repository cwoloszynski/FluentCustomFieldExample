import Foundation
import Node

extension Date: NodeInitializable {
    
    public init(node: Node, in context: Context) throws {
        
        switch (node) {
        case .number (let number):
            switch (number) {
            case .int(let secondsSince1970):
                self = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
                return
            case .double(let secondsSince1970):
                self = Date(timeIntervalSince1970: secondsSince1970)
                return
            default:
                break
            }
        case .string (let string):
            // JSON requires a specific Date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: string) else {
                throw NodeError.unableToConvert(node: node, expected: "\(String.self)")
            }
            self = date
            return
        default:
            break
        }
        throw NodeError.unableToConvert(node: node, expected: "\(String.self)")
    }
}
