import Fluent
import Vapor

final class Vote: Model, Content {
    static let schema = "votes"
    
    
    @ID var id: UUID?
    @Field(key: "user") var user: UUID
    @Parent(key: "topicId") var topic: Topic
    
    init() {}
    
    init(
        id: UUID? = nil,
        topic: Topic.IDValue,
        user: UUID
    ) {
        self.user = user
        self.$topic.id = topic
    }

}
