import Fluent
import Vapor

final class Vote: Model, Content {
    static let schema = "votes"
    
    
    @ID var id: UUID?
    @Field(key: "user") var user: UUID
    @Field(key: "topic") var topic: UUID
    
    init() {}
    
    init(
        id: UUID? = nil,
        topic: UUID,
        user: UUID
    ) {
        self.user = user
        self.topic = topic
    }

}
