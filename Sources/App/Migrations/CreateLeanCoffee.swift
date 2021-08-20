import Fluent
import Vapor

struct CreateLeanCoffee: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(LeanCoffee.schema)
            .id()
            .field("title", .string, .required)
            .field("date", .date, .required)
            .field("host", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(LeanCoffee.schema).delete()
    }
}
