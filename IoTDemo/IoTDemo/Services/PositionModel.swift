import Foundation
import RealmSwift

class PositionRealm: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var source: String = ""
    @objc dynamic var user: String = ""
    @objc dynamic var createdDate = Date()
}

