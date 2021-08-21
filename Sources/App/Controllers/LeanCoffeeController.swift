import Vapor
import Fluent

struct LeanCoffeeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let authMiddleWare = Token.authenticator()
        let guardMiddleWare = User.guardMiddleware()
        
        let route = routes
            .grouped("api", "leancoffee")
            .grouped(authMiddleWare, guardMiddleWare)

        route.post(use: create)
        route.get(use: getAll)
        route.get(":id", use: getByID)
        route.get(":id", "host", use: getHost)
        route.get(":id", "topics", use: getAllTopics)
        
        route.webSocket(":id", "live") { req, webSocket in
            webSocket.send("connected")
        }

    }
    
    func create(_ req: Request) throws -> EventLoopFuture<LeanCoffee> {
        let data = try req.content.decode(CreateLeanCoffeeData.self)
        let user = try req.auth.require(User.self)
        
        let leanCoffee = try LeanCoffee(
            title: data.title,
            host: user.requireID(),
            date: Date()
        )
        
        return req.saveAndReturn(object: leanCoffee)
    }
    
    
    func getAll(_ req: Request) throws -> EventLoopFuture<[LeanCoffee]> {
        LeanCoffee.query(on: req.db).all()
    }
    
    func getByID(_ req: Request) throws -> EventLoopFuture<LeanCoffee> {
        LeanCoffee.findAndUnwrap(req.getID(), on: req.db)
    }
    
    func getHost(_ req: Request) throws -> EventLoopFuture<User.Public> {
        LeanCoffee
            .findAndUnwrap(req.getID(), on: req.db)
            .flatMap {
                User.findAndUnwrap($0.host, on: req.db)
                    .map(\.public)
            }
    }
    
    func getAllTopics(_ req: Request) throws -> EventLoopFuture<[HydratedTopic]> {
        LeanCoffee
            .query(on: req.db)
            .with(\.$topics) {
                $0.with(\.$votes)
            }
            .all()
            .flatMapThrowing { leanCoffies in
                try leanCoffies.flatMap { lc in
                    try lc.topics.compactMap {
                        try HydratedTopic(
                            id: $0.requireID(),
                            title: $0.title,
                            introducer: $0.introducer,
                            description: $0.description,
                            completed: $0.completed,
                            votes: $0.votes
                        )
                    }
                }
            }
    }
}
