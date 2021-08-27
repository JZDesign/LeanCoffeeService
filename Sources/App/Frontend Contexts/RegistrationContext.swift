import Vapor
import Foundation

struct RegistrationContext: Encodable {
    let title = "Register"
    
    func view(_ req: Request) ->  EventLoopFuture<View> { req.view.render("register", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        RegistrationContext().view(req)
    }
    
    static func postHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        
        let data = try req.content.decode(RegistrationData.self)
        let password = try Bcrypt.hash(data.password)
        let user = data.user(withPassword: password)
        return user.save(on: req.db)
            .map { req.auth.login(user) }
            .transform(to: req.redirect(to: "/"))
    }
}

struct RegistrationData: Content {
  let name: String
  let username: String
  let password: String
  let confirmPassword: String
    
    func user(withPassword pass: String) -> User {
        User(name: name, password: pass, username: username)
    }
}
