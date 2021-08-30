
import Vapor
import Foundation

struct LoginContext: Encodable {
    let title = "Log In"
    let loginError: Bool
    
    init(loginError: Bool = false) {
        self.loginError = loginError
    }
    
    func handler(_ req: Request) -> EventLoopFuture<View> {
        let context: LoginContext
        
        if let error = req.query[Bool.self, at: "error"], error {
            context = LoginContext(loginError: true)
        } else {
            context = LoginContext()
        }
        
        return req.view
            .render("login", context)
    }
    
    func postHandler(_ req: Request) -> EventLoopFuture<Response> {
      if req.auth.has(User.self) {
        return req.eventLoop.future(req.redirect(to: "/"))
      } else {
        return req.view
            .render("login", LoginContext(loginError: true))
            .encodeResponse(for: req)
      }
    }
}
