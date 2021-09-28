import Vapor
import Fluent


struct EditLeanCoffeeContext: Encodable {
    lazy var title = "Editing \(leanCoffee.title)"
    let leanCoffee: LeanCoffee
    let editing = true

    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("createLeanCoffee", self) }

    static func handler(_ req: Request) throws -> EventLoopFuture<View> {
        let user = try req.auth.require(User.self)
        return LeanCoffee
            .findAndUnwrap(req.getID("leanCoffeeID"), on: req.db)
            .flatMap {
                EditLeanCoffeeContext(leanCoffee: $0).view(req)
            }
    }
    
    static func postHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(CreateLeanCoffeeData.self)
        
        return LeanCoffee
            .findAndUnwrap(req.getID("leanCoffeeID"), on: req.db)
            .flatMap { lc in
                lc.title = data.title
                return lc
                    .save(on: req.db)
                    .transform(to: req.redirect(to: lc.path))
            }
    }
}
