import Vapor
import Foundation

struct LeanCoffeeContext: Encodable {
    let title: String
    let leanCoffee: LeanCoffee
    let user: User
    
    
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("leanCoffee", self) }
    
    static func handler(_ req: Request) -> EventLoopFuture<View> {
        LeanCoffee.findAndUnwrap("leanCoffeeID", with: req)
            .flatMap { leanCoffee in
                User.findAndUnwrap(leanCoffee.host, on: req.db)
                    .flatMap { user in
                        LeanCoffeeContext(
                            title: leanCoffee.title,
                            leanCoffee: leanCoffee,
                            user: user).view(req)
                    }
            }
    }
    
    static func deleteHandler(_ req: Request) -> EventLoopFuture<Response> {
        LeanCoffee.findAndUnwrap("leanCoffeeID", with: req)
            .flatMap {
                $0.delete(on: req.db).transform(to: req.redirect(to: "/"))
            }
    }
}
