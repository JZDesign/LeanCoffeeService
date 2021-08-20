import Vapor
import Fluent

extension Model {
    var path: String {
        let path = "/\(type(of: self).schema)"
        
        guard let id = id else {
            return path
        }
        
        return path + "/\(id)"
    }
    
    static func findAndUnwrap(_ id: Self.IDValue?, on db: Database) -> EventLoopFuture<Self> {
        return find(id, on: db)
            .unwrap(or: Abort(.notFound))
    }
    
    static func findAndUnwrap(_ id: String?, with request: Request) -> EventLoopFuture<Self> {
        return findAndUnwrap(request.getID(id ?? "") as? Self.IDValue, on: request.db)
    }

}

extension Request {
    func getID(_ param: String = "id") -> UUID? {
        guard let id = parameters.get(param) else {
            return nil
        }
        
        return UUID(id)
    }
}
