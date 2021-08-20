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
}
