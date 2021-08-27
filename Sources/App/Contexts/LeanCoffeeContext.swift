import Vapor
import Fluent
import Foundation

struct LeanCoffeeContext: Encodable {
    let title: String
    let leanCoffee: LeanCoffee
    let topics: [HydratedTopic]
    let user: User

    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("leanCoffee", self) }

    static func handler(_ req: Request) -> EventLoopFuture<View> {
        getHydratedTopics(req, idKey: "leanCoffeeID")
            .flatMap { leanCoffee, topics in
                User.findAndUnwrap(leanCoffee.host, on: req.db)
                    .flatMap { user in
                        LeanCoffeeContext(
                            title: leanCoffee.title,
                            leanCoffee: leanCoffee,
                            topics: topics,
                            user: user)
                            .view(req)
                    }
            }
    }
    
    static func getHydratedTopics(_ req: Request, idKey: String) -> EventLoopFuture<(LeanCoffee, [HydratedTopic])> {
        guard let id = req.getID(idKey) else {
            return req.eventLoop.makeFailedFuture(Abort(.notFound))
        }
        
        return LeanCoffee
            .query(on: req.db)
            .filter(\.$id == id)
            .with(\.$topics, { $0.with(\.$votes) })
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { leanCoffee in
                let topics = try leanCoffee.topics.compactMap {
                    try HydratedTopic(
                        id: $0.requireID(),
                        title: $0.title,
                        introducer: $0.introducer,
                        description: $0.description,
                        completed: $0.completed,
                        votes: $0.votes
                    )
                }
                return (leanCoffee, topics) as (LeanCoffee, [HydratedTopic])
            }
    }
    
    static func deleteHandler(_ req: Request) -> EventLoopFuture<Response> {
        LeanCoffee.findAndUnwrap("leanCoffeeID", with: req)
            .flatMap {
                $0.delete(on: req.db).transform(to: req.redirect(to: "/"))
            }
    }
}
