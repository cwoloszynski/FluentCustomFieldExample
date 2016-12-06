import Foundation
import Node

extension Date: NodeRepresentable {
    /**
     Turn the convertible into a node
     
     - throws: if convertible can not create a Node
     - returns: a node if possible
     */
    public func makeNode(context: Context) throws -> Node {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = dateFormatter.string(from:self)
        
        return Node(string)
    }
}

extension Date: NodeInitializable {

    public init(node: Node, in context: Context) throws {
        
        switch (node) {
        case .string (let string):
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
