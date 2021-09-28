import Vapor
import Fluent

struct EditTopicContext: Encodable {
    lazy var title = "Editing \(topic.title)"
    let topic: Topic
    let editing = true
    private static let CSRF_KEY = "CSRF_TOKEN"
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("createTopic", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        Topic
            .findAndUnwrap(req.getID("topicID"), on: req.db)
            .flatMap {
                EditTopicContext(topic: $0).view(req)
            }
    }
    
    static func postHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(CreateTopicFormData.self)
        return Topic
            .findAndUnwrap(req.getID("topicID"), on: req.db)
            .flatMap { topic in
                topic.title = data.title
                topic.description = data.description ?? ""
                return topic
                    .save(on: req.db)
                    .transform(to: req.redirect(to: topic.path))
            }
    }
}
