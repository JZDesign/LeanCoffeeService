import Fluent
import Vapor

final class Topic: Model, Content {
    static let schema = "topics"
    
    
    @ID var id: UUID?
    @Field(key: "title") var title: String
    @Field(key: "description") var description: String
    @Field(key: "introducer") var introducer: UUID
    @Field(key: "completed") var completed: Bool
    @Parent(key: "leanCoffee") var leanCoffee: LeanCoffee

    
    init() {}
    
    init(
        id: UUID? = nil,
        title: String,
        introducer: UUID,
        description: String,
        completed: Bool = false
    ) {
        self.title = title
        self.description = description
        self.introducer = introducer
        self.completed = completed
    }

}
