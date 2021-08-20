import Fluent
import Vapor

struct CreateVote: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(Vote.schema)
            .id()
            .field("user", .uuid, .required)
            .field("topicId", .uuid, .required, .references(Topic.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Vote.schema).delete()
    }
}
