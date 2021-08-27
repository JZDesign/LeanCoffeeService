import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    var `public`: User.Public {
        User.Public(id: id, name: name, username: username)
    }
    
    @ID var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "username") var username: String
    @Field(key: "password") var password: String

    
    init() {}
    
    init(id: UUID? = nil, name: String, password: String, username: String) {
        self.name = name
        self.username = username
        self.password = password
    }
    
    
    struct Public: Content {
        var id: UUID?
        var name: String
        var username: String
    }
    
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

// Session Cookies
extension User: ModelSessionAuthenticatable {}

extension User: ModelCredentialsAuthenticatable {}


public protocol ModelCredentialsAuthenticatable: Model, Authenticatable {
    static var usernameKey: KeyPath<Self, Field<String>> { get }
    static var passwordHashKey: KeyPath<Self, Field<String>> { get }
    func verify(password: String) throws -> Bool
}

extension ModelCredentialsAuthenticatable {
    public static func credentialsAuthenticator(
        database: DatabaseID? = nil
    ) -> Authenticator {
        ModelCredentialsAuthenticator<Self>(database: database)
    }

    var _$username: Field<String> {
        self[keyPath: Self.usernameKey]
    }

    var _$passwordHash: Field<String> {
        self[keyPath: Self.passwordHashKey]
    }
}

public struct ModelCredentials: Content {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

private struct ModelCredentialsAuthenticator<User>: CredentialsAuthenticator
    where User: ModelCredentialsAuthenticatable
{
    typealias Credentials = ModelCredentials

    public let database: DatabaseID?

    func authenticate(credentials: ModelCredentials, for request: Request) -> EventLoopFuture<Void> {
        User.query(on: request.db(self.database)).filter(\._$username == credentials.username).first().flatMapThrowing { foundUser in
            guard let user = foundUser else {
                return
            }
            guard try user.verify(password: credentials.password) else {
                return
            }
            request.auth.login(user)
        }
    }
}

