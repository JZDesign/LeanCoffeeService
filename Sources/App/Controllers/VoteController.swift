import Vapor
import Fluent

struct VoteController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let authMiddleWare = Token.authenticator()
        let guardMiddleWare = User.guardMiddleware()
        
        let route = routes
            .grouped("api", "votes")
            .grouped(authMiddleWare, guardMiddleWare)

        route.post(use: create)
        route.get(use: getAll)
        route.get(":id", use: getByID)
        route.get(":id", "topic", use: getTopic)
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Vote> {
        let data = try req.content.decode(Vote.self)
        let user = try req.auth.require(User.self)
                
        let vote = try Vote(
            topic: data.topic.requireID(),
            user: user.requireID()
        )
        
        return req.saveAndReturn(object: vote)
    }
    
    
    func getAll(_ req: Request) throws -> EventLoopFuture<[Vote]> {
        Vote.query(on: req.db).all()
    }
    
    func getByID(_ req: Request) throws -> EventLoopFuture<Vote> {
        Vote.findAndUnwrap(req.getID(), on: req.db)
    }
    
    func getTopic(_ req: Request) throws -> EventLoopFuture<Topic> {
        Vote
            .findAndUnwrap(req.getID(), on: req.db)
            .flatMap {
                Topic.findAndUnwrap($0.topic.id, on: req.db)
            }
    }
}
