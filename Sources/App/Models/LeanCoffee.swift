import Fluent
import Vapor

final class LeanCoffee: Model, Content {
    static let schema = "leanCoffee"
    
    @ID var id: UUID?
    @Field(key: "title") var title: String
    @Field(key: "date") var date: Date
    @Field(key: "host") var host: UUID
    @Children(for: \.$leanCoffee) var topics: [Topic]

    init() {}
    
    init(
        id: UUID? = nil,
        title: String,
        host: UUID,
        date: Date
    ) {
        self.title = title
        self.date = date
        self.host = host

    }

}
