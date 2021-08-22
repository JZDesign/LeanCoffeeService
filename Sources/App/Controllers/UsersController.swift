import Vapor

struct UsersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
       
        let authMiddleWare = Token.authenticator()
        let guardMiddleWare = User.guardMiddleware()
        let basicAuthMiddleware = User.authenticator()
        
        let route = routes.grouped("api", "users")
    
        let protectedRoutes = route
            .grouped(authMiddleWare, guardMiddleWare)
        
        let basicAuthGroup = route.grouped(basicAuthMiddleware)
        
        route.post(use: createUser)
        
        protectedRoutes.get(use: getAll)
        protectedRoutes.get(":userID", use: getUser)
        
        basicAuthGroup.post("login", use: loginHandler)
        
    }
    
    
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req.db).map { token }
    }
    
    func createUser(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map { user.public }
    }
    
    
    func getAll(_ req: Request) throws -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }
    
    func getUser(_ req: Request) throws -> EventLoopFuture<User.Public> {
        User.findAndUnwrap(req.getID("userID"), on: req.db).convertToPublic()
    }

    
}


extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        self.map { $0.public }
        
    }
}


extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        self.map { $0.public }
    }
}


extension EventLoopFuture where Value == Array<User> {
    
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        map { $0.convertToPublic() }
    }
}
