import Foundation
import RealmSwift

class HistoryMessageRealm: Object {
    @objc dynamic var edgets: Int64 = 0
    @objc dynamic var dateCreated = Date()
    @objc dynamic var dateEdgets = Date()
    @objc dynamic var source = ""
    @objc dynamic var client: NetworkDeviceRealm?

    override static func primaryKey() -> String? {
        return "edgets"
    }
}
class NetworkDeviceRealm: Object {
    @objc dynamic var eui: String = ""

    override static func primaryKey() -> String? {
        return "eui"
    }
}

class WaterMessageRealm: HistoryMessageRealm {
    @objc dynamic var waterLevel: Int = 0
    @objc dynamic var waterPresence: Int = 0
    @objc dynamic var soilHumidity: Int = 0
}

class GeoMessageRealm: HistoryMessageRealm {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var precision: Double = 0.0
}