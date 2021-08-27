import Vapor
import Foundation

struct IndexContext: Encodable {
    let title: String
    let leanCoffeeEvents: [LeanCoffee]
    let userLoggedIn: Bool

    func view(_ req: Request) ->  EventLoopFuture<View> { req.view.render("index", self) }
    
    static func handler(_ req: Request) throws -> EventLoopFuture<View> {
        LeanCoffee.query(on: req.db).all()
            .flatMap {
                IndexContext(
                    title: "Lean Coffee",
                    leanCoffeeEvents: $0.reversed(),
                    userLoggedIn: req.auth.has(User.self)
                ).view(req)
            }
    }
}
