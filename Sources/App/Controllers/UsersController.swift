import Vapor

struct UsersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("api", "users")
        
        route.post(use: createUser) // delete this and replace with ...
        /**
         
         let tokenAuthMiddleware = Token.authenticator()
         let guardAuthMiddleware = User.guardMiddleware()
         let tokenAuthGroup = usersRoute.grouped(
            tokenAuthMiddleware,
            guardAuthMiddleware)
         tokenAuthGroup.post(use: createUser)
         
         //[BOOK] Again, using tokenAuthMiddleware and guardAuthMiddleware ensures only authenticated users can create other users. This prevents anyone from creating a user to send requests to the routes you’ve just protected!

         //[BOOK] Now all API routes that can perform “destructive” actions — that is create, edit or delete resources — are protected. For those actions, the application only accept requests from authenticated users.
         
         // I think I would prefer to inspect the token and make sure the user has authority to make a change instead of doing this...
         */
        
        
        route.get(use: getAll)
        route.get(":userID", use: getUser)
        
        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = route.grouped(basicAuthMiddleware)
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
