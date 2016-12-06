import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var content: String
    var postedOn: Date
    
    struct Keys {
        static let id = "id"
        static let content = "content"
        static let postedOn = "posted_on"
    }
    
    init(content: String) {
        self.id = UUID().uuidString.makeNode()
        self.content = content
        self.postedOn = Date()
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract(Keys.id)
        content = try node.extract(Keys.content)
        postedOn = try node.extract(Keys.postedOn)
    }

    func makeNode(context: Context) throws -> Node {
        
        return try Node(node: [
            Keys.id: id,
            Keys.content: content,
            Keys.postedOn: postedOn
        ])
    }
}

extension Post {
    /**
        This will automatically fetch from database, using example here to load
        automatically for example. Remove on real models.
    */
    public convenience init?(from string: String) throws {
        self.init(content: string)
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(entity) { post in
            post.id(Keys.id)
            post.string(Keys.content)
            post.custom(Keys.postedOn, type: "DATETIME")
        }
    }

    static func revert(_ database: Database) throws {
        //
    }
}
