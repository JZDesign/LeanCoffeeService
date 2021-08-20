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
//    @Children(for: \.$user) var votes: [Vote]

    
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
