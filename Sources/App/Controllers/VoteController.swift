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
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Vote> {
        let data = try req.content.decode(SubmitVote.self)
        let user = try req.auth.require(User.self)
                
        let vote = try Vote(
            topic: data.topicId,
            user: user.requireID()
        )
        
        return Vote
            .query(on: req.db)
            .with(\.$topic)
            .all()
            .flatMapThrowing { allVotes in
                let dupe = allVotes
                    .filter {
                        $0.user == user.id
                        && $0.topic.id == data.topicId
                    }
                if dupe.count > 0 {
                    throw Abort(.conflict)
                }
            }
            .flatMapThrowing {
                try vote.save(on: req.db)
                return vote
            }
    }
    
    
    func getAll(_ req: Request) throws -> EventLoopFuture<[Vote]> {
        Vote.query(on: req.db).all()
    }
    
    func getByID(_ req: Request) throws -> EventLoopFuture<Vote> {
        Vote.findAndUnwrap(req.getID(), on: req.db)
    }

}
