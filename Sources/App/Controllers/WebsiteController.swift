import Vapor
import Leaf

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sessionRoute = routes.grouped(User.sessionAuthenticator())
        let protectedRoute = sessionRoute.grouped(User.redirectMiddleware(path: LeanCoffeePath.login.value))
        let authRoute = sessionRoute.grouped(User.credentialsAuthenticator())
        
        try Router(
            sessionRoute: sessionRoute,
            protectedRoute: protectedRoute,
            authRoute: authRoute
        ).setup()
    }
    
}

struct Router {
    let sessionRoute: RoutesBuilder
    let protectedRoute: RoutesBuilder
    let authRoute: RoutesBuilder
    
    func setup() throws {
        try indexRoutes()
        try registraionRoutes()
        try signInOutRoutes()
        try userRoutes()
        try leanCoffeeRoutes()
        try topicRoutes()
    }
    
    private func registraionRoutes() throws {
        sessionRoute.get(.register, handler: RegistrationContext.handler)
        sessionRoute.post(.register, handler: RegistrationContext.postHandler)
    }
    
    private func indexRoutes() throws {
        protectedRoute.get(handler: IndexContext.handler)
    }
    
    private func signInOutRoutes() throws {
        sessionRoute.get(.login, handler: LoginContext().handler)
        authRoute.post(.login, handler: LoginContext().postHandler)
        sessionRoute.post(.logout, handler: logoutHandler)
    }
    
    private func leanCoffeeRoutes() throws {
        protectedRoute.get(.leanCoffee, .create, handler: CreateLeanCoffeeContext.handler)
        protectedRoute.post(.leanCoffee, .create, handler: CreateLeanCoffeeContext.postHandler)
        
        protectedRoute.get(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            handler: LeanCoffeeContext.handler
        )
        
        protectedRoute.get(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            .edit,
            handler: EditLeanCoffeeContext.handler
        )
        
        protectedRoute.post(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            .edit,
            handler: EditLeanCoffeeContext.postHandler
        )
        
        protectedRoute.get(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            .delete,
            handler: LeanCoffeeContext.deleteHandler
        )
    }
    
    private func topicRoutes() throws {
        protectedRoute.get(
            .topics,
            .parameter(.topicID),
            handler: TopicContext.handler)
        
        protectedRoute.get(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            .topics,
            .create,
            handler: CreateTopicContext.handler)
        
        protectedRoute.post(
            .leanCoffee,
            .parameter(.leanCoffeeID),
            .topics,
            .create,
            handler: CreateTopicContext.postHandler)
        
        
        protectedRoute.get(
            .topics,
            .parameter(.topicID),
            .edit,
            handler: EditTopicContext.handler
        )
        
        protectedRoute.post(
            .topics,
            .parameter(.topicID),
            .edit,
            handler: EditTopicContext.postHandler
        )
        
        
        protectedRoute.get(
            .topics,
            .parameter(.topicID),
            .votes,
            .create,
            handler: TopicContext.voteHandler)
        
        protectedRoute.get(
            .topics,
            .parameter(.topicID),
            .complete,
            handler: TopicContext.completeHandler)
        
        protectedRoute.get(
            .topics,
            .parameter(.topicID),
            .delete,
            handler: TopicContext.deleteHandler)
    }
    
    
    private func userRoutes() throws {
        sessionRoute.get(.users, .parameter(.userID), handler: UserContext.handler)
        sessionRoute.get(.users, handler: AllUsersContext.handler)
    }
    
    
    private func logoutHandler(_ req: Request) -> Response {
        req.auth.logout(User.self)
        return req.redirectToIndex()
    }
}

enum LeanCoffeePathParameter: String {
    case userID, leanCoffeeID, topicID
}

enum LeanCoffeePath {
    case login, logout, register, complete, create, delete, leanCoffee, topics, votes, edit, users, parameter(LeanCoffeePathParameter)
    
    var path: PathComponent {
        switch self {
        case .parameter(let val): return ":\(val.rawValue)"
        case .login: return "login"
        case .logout: return "logout"
        case .register: return "register"
        case .create: return "create"
        case .complete: return "complete"
        case .delete: return "delete"
        case .leanCoffee: return "leanCoffee"
        case .topics: return "topics"
        case .votes: return "votes"
        case .edit: return "edit"
        case .users: return "users"
        }
    }
    
    var value: String { return "/\(path)" }
}


extension RoutesBuilder {
    @discardableResult
    func post<Response>(_ paths: LeanCoffeePath..., handler: @escaping (Request) throws -> Response) -> Route where Response : ResponseEncodable {
        post(paths.compactMap { $0.path }, use: handler)
    }
    
    @discardableResult
    func get<Response>(_ paths: LeanCoffeePath..., handler: @escaping (Request) throws -> Response) -> Route where Response : ResponseEncodable {
        get(paths.compactMap { $0.path }, use: handler)
    }
    
    @discardableResult
    func put<Response>(_ paths: LeanCoffeePath..., handler: @escaping (Request) throws -> Response) -> Route where Response : ResponseEncodable {
        put(paths.compactMap { $0.path }, use: handler)
    }
    
    @discardableResult
    func delete<Response>(_ paths: LeanCoffeePath..., handler: @escaping (Request) throws -> Response) -> Route where Response : ResponseEncodable {
        delete(paths.compactMap { $0.path }, use: handler)
    }
    
    @discardableResult
    func patch<Response>(_ paths: LeanCoffeePath..., handler: @escaping (Request) throws -> Response) -> Route where Response : ResponseEncodable {
        patch(paths.compactMap { $0.path }, use: handler)
    }
}

extension Request {
    func redirectToIndex() -> Response {
        redirect(to: "/")
    }
}
