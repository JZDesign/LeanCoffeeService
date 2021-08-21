import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("ready") { _ in return HTTPStatus.ok }

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.webSocket(":id", "live") { req, webSocket in
        webSocket.send("connected")
        webSocket.onText {
            $0.send("text received: \($1)")
        }
        
        webSocket.onPing {
            $0.send("ping")
        }
    }
    try app.register(collection: UsersController())
    try app.register(collection: LeanCoffeeController())
    try app.register(collection: TopicController())
    try app.register(collection: VoteController())
}
