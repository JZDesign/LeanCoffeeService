import Fluent
import Vapor
import PostgresNIO

final class Topic: Model, Content {
    static let schema = "topics"
    
    
    @ID var id: UUID?
    @Field(key: "title") var title: String
    @Field(key: "description") var description: String
    // The id of the user who wanted to talk about the topic
    @Field(key: "introducer") var introducer: UUID
    @Field(key: "completed") var completed: Bool
    @Parent(key: "leanCoffeeId") var leanCoffee: LeanCoffee
    @Children(for: \.$topic) var votes: [Vote]
    
    init() {}
    
    init(
        id: UUID? = nil,
        title: String,
        introducer: UUID,
        description: String,
        completed: Bool = false,
        leanCoffeeId: LeanCoffee.IDValue
    ) {
        self.title = title
        self.description = description
        self.introducer = introducer
        self.completed = completed
        self.$leanCoffee.id = leanCoffeeId
    }
}

struct CreateTopicData: Content {
    let title: String
    let description: String?
    let leanCoffeeId: UUID
}

struct HydratedTopic: Content {
    
    let id: UUID
    let title: String
    let introducer: UUID
    let description: String
    let completed: Bool
    let votes: [Vote]
    
    init(
        id: UUID,
        title: String,
        introducer: UUID,
        description: String,
        completed: Bool = false,
        votes: [Vote]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.introducer = introducer
        self.completed = completed
        self.votes = votes
    }
}
