import Vapor
import Fluent
import Foundation

struct LeanCoffeeContext: Encodable {
    let title: String
    let leanCoffee: LeanCoffee
    let topics: [HydratedTopic]
    let user: User

    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("leanCoffee", self) }

    static func handler(_ req: Request) throws -> EventLoopFuture<View> {
        let user = try req.auth.require(User.self)

        return LeanCoffeeController.getHydratedTopics(req, idKey: "leanCoffeeID")
            .flatMap { (leanCoffee, topics) in
                let sorted = topics
                    .sorted { $1.votes.count < $0.votes.count }
                    .sorted { !$0.completed && $1.completed }
                return LeanCoffeeContext(
                    title: leanCoffee.title,
                    leanCoffee: leanCoffee,
                    topics: sorted,
                    user: user)
                    .view(req)
            }
    }
        
    static func deleteHandler(_ req: Request) -> EventLoopFuture<Response> {
        LeanCoffee.findAndUnwrap("leanCoffeeID", with: req)
            .flatMap {
                $0.delete(on: req.db).transform(to: req.redirect(to: "/"))
            }
    }
}
