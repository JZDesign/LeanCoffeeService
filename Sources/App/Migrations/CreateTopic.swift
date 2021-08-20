import Fluent
import Vapor

struct CreateTopic: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(Topic.schema)
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("introducer", .uuid, .required)
            .field("completed", .bool, .required)
            .field("leanCoffeeId", .uuid, .required, .references(LeanCoffee.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Topic.schema).delete()
    }
}
