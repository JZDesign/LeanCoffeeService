import Vapor
import Fluent

struct TopicController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let authMiddleWare = Token.authenticator()
        let guardMiddleWare = User.guardMiddleware()
        
        let route = routes
            .grouped("api", "topics")
            .grouped(authMiddleWare, guardMiddleWare)

        route.post(use: create)
        route.get(use: getAll)
        route.get(":id", use: getByID)
        route.get(":id", "introducer", use: getIntroducer)
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Topic> {
        let data = try req.content.decode(CreateTopicData.self)
        let user = try req.auth.require(User.self)
                
        let topic = try Topic(
            title: data.title,
            introducer: user.requireID(),
            description: data.description ?? "",
            completed: false,
            leanCoffeeId: data.leanCoffeeId
        )
        
        return req.saveAndReturn(object: topic)
    }
    
    
    func getAll(_ req: Request) throws -> EventLoopFuture<[Topic]> {
        Topic.query(on: req.db).all()
    }
    
    func getByID(_ req: Request) throws -> EventLoopFuture<Topic> {
        Topic.findAndUnwrap(req.getID(), on: req.db)
    }
    
    func getIntroducer(_ req: Request) throws -> EventLoopFuture<User.Public> {
        Topic
            .findAndUnwrap(req.getID(), on: req.db)
            .flatMap {
                User.findAndUnwrap($0.introducer, on: req.db)
                    .map(\.public)
            }
    }
}
