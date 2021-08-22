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
        
        route.get(":id", "leancoffee", use: getLeanCoffee)
        route.get(":id", "introducer", use: getIntroducer)
        route.get(":id", "votes", use: getAllVotes)
        
        route.post(":id", "complete", use: completeTopic)
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
    
    func getLeanCoffee(_ req: Request) throws -> EventLoopFuture<LeanCoffee> {
        Topic
            .findAndUnwrap(req.getID(), on: req.db)
            .flatMap {
                LeanCoffee.findAndUnwrap($0.$leanCoffee.id, on: req.db)
            }
    }
    
    func getAllVotes(_ req: Request) throws -> EventLoopFuture<[Vote]> {
        Topic
            .findAndUnwrap(req.getID(), on: req.db)
            .flatMap { $0.$votes.get(on: req.db) }
    }
    
    func completeTopic(_ req: Request) throws -> EventLoopFuture<Topic> {
        Topic
            .findAndUnwrap(req.getID(), on: req.db)
            .map {
                $0.completed = true
                $0.save(on: req.db)
                return $0
            }
    }
}
