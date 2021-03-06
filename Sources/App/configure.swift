import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(app.sessions.middleware)

    configureHeroku(app: app) ?? configureDatabase(app)

    app.views.use(.leaf)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateAdminUser())
    app.migrations.add(CreateToken())
    app.migrations.add(CreateLeanCoffee())
    app.migrations.add(CreateTopic())
    app.migrations.add(CreateVote())

//    try app.autoRevert().wait()

    try app.autoMigrate().wait()

    try routes(app)
}


func configureHeroku(app: Application) -> Void? {
    if var config = Environment.get("DATABASE_URL")
        .flatMap(URL.init)
        .flatMap(PostgresConfiguration.init) {
            config.tlsConfiguration = .forClient(certificateVerification: .none)
              app.databases.use(.postgres(configuration: config), as: .psql)
        return ()
    } else {
        return nil
    }
}

func configureDatabase(_ app: Application) {
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let databaseUserName = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    var database = Environment.get("DATABASE_NAME") ?? "lean_coffee_database"
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
