import Vapor
import Fluent
import Foundation

struct TopicContext: Encodable {
    let title: String
    let topic: Topic
    let user: User
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("topic", self) }
    
    static func handler(_ req: Request) throws -> EventLoopFuture<View> {
        guard let topicID = req.getID("topicID") else {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }
        let user = try req.auth.require(User.self)
        
        return Topic
            .query(on: req.db)
            .filter(\.$id == topicID)
            .with(\.$votes)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { topic in
                TopicContext(
                    title: topic.title,
                    topic: topic,
                    user: user
                ).view(req)
            }
    }
    
    static func voteHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        guard let topicID = req.getID("topicID") else {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }

        let user = try req.auth.require(User.self)

        let vote = try Vote(topic: topicID, user: user.requireID())
        
        return try VoteController
            .create(req, vote)
            .flatMapError { _ in req.eventLoop.makeSucceededVoidFuture().map { vote } }
            .transform(to: req.redirect(to: "/topics/\(topicID)"))
    }
    
    static func completeHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        guard let topicID = req.getID("topicID") else {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }

        _ = try req.auth.require(User.self)
        
        return Topic
            .findAndUnwrap(topicID, on: req.db)
            .flatMapThrowing { (topic: Topic) -> Void in
                topic.completed = true
                _ = req.saveAndReturn(object: topic)
                return ()
            }.transform(to: req.redirect(to: "/topics/\(topicID)"))
    }
}

struct CreateTopicContext: Encodable {
    let title = "Create a Topic"
    let csrfToken: String
    
    private static let CSRF_KEY = "CSRF_TOKEN"
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("createTopic", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        let token = [UInt8].random(count: 16).base64
        let context = CreateTopicContext(csrfToken: token)
        req.session.data[CSRF_KEY] = token
        
        return context.view(req)
    }
    
    static func postHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        guard let leanCoffeeId = req.getID("leanCoffeeID") else {
            return req.eventLoop.makeFailedFuture(Abort(.badRequest))
        }
        
        let user = try req.auth.require(User.self)

        let data = try req.content.decode(CreateTopicFormData.self)
        try validateCSRF(data, req)
     
        let topic = Topic(
            title: data.title,
            introducer: user.id!,
            description: data.description ?? "",
            completed: false,
            leanCoffeeId: leanCoffeeId
        )
        
        return topic.save(on: req.db)
            .transform(to: req.redirect(to: topic.path))
        
        
    }
    
    
    private static func validateCSRF(
        _ data: CreateTopicFormData,
        _ req: Request
    ) throws {
        let expectedToken = req.session.data[CSRF_KEY]
        req.session.data[CSRF_KEY] = nil
        
        guard let csrfToken = data.csrfToken,
              expectedToken == csrfToken
        else {
            throw Abort(.badRequest)
        }
    }
}

struct CreateTopicFormData: Content {
    let title: String
    let description: String?
    var csrfToken: String? = nil
}
