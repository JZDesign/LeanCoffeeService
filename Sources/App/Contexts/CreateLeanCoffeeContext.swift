import Vapor
import Foundation
import Fluent

struct CreateLeanCoffeeContext: Encodable {
    let title = "Create a Lean Coffee"
    let csrfToken: String
    private static let CSRF_KEY = "CSRF_TOKEN"
    
    func view(_ req: Request) -> EventLoopFuture<View> { req.view.render("createLeanCoffee", self) }

    static func handler(_ req: Request) -> EventLoopFuture<View> {
        let token = [UInt8].random(count: 16).base64
        let context = CreateLeanCoffeeContext(csrfToken: token)
        req.session.data[CSRF_KEY] = token

        return context.view(req)
    }
    
    static func postHandler(_ req: Request) throws -> EventLoopFuture<Response> {
        
        let data = try req.content.decode(CreateLCFormData.self)
        try validateCSRF(data, req)
        return try LeanCoffee.create(data, for: req)
    }
    
    private static func validateCSRF(
        _ data: CreateLCFormData,
        _ req: Request
    ) throws {
        let expectedToken = req.session.data[CSRF_KEY]
        req.session.data[CSRF_KEY] = nil
        
        guard let csrfToken = data.csrfToken,
              expectedToken == csrfToken
        else {
          throw Abort(.badRequest)
        }
    }
}


struct CreateLCFormData: Content {
    let title: String
    var csrfToken: String? = nil
}


extension LeanCoffee {
    static func create(_ data: CreateLCFormData, for req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let lc = try LeanCoffee(title: data.title, host: user.requireID(), date: Date())
        
        return lc.save(on: req.db)
            .transform(to: req.redirect(to: lc.path))
    }
}
