import Foundation
import RealmSwift

class BackendRealm: Object {
    @objc dynamic var connectionString = ""
    @objc dynamic var lastUsed = Date()

    override static func primaryKey() -> String? {
        return "connectionString"
    }
}
