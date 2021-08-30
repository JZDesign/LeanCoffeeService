import Vapor
import Foundation

struct UserContext: Encodable {
    let title: String
    let user: User
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("user", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        User.findAndUnwrap("userID", with: req)
            .flatMap { user in
                UserContext(title: user.name, user: user).view(req)
            }
    }
}

struct AllUsersContext: Encodable {
    let title: String
    let users: [User]
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("allUsers", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        User.query(on: req.db).all()
            .flatMap { AllUsersContext(title: "All Users", users: $0).view(req) }
    }
}
