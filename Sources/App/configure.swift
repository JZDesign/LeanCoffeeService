import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)

    configureDatabase(app)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateAdminUser())

    // register routes
    try routes(app)
}


func configureDatabase(_ app: Application) {
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let databaseUserName = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    var database = Environment.get("DATABASE_NAME") ?? "vapor_database"
    var databasePort = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? PostgresConfiguration.ianaPortNumber
    
    if app.environment == .testing {
        database = "vapor-test"
        databasePort = Environment.get("DATABASE_PORT")?.toInt() ?? 5433
    }
    
    app.databases.use(.postgres(
        hostname: hostname,
        port: databasePort,
        username: databaseUserName,
        password: password,
        database: database
    ), as: .psql)

}

extension String {
    func toInt() -> Int? { Int(self) }
}
