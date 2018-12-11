import Foundation
import RealmSwift

class DeviceDataRealmAdapter: DeviceServiceDelegate {
    var realm: Realm!

    init() {
        realm = try! Realm(configuration: realmConfig)
    }

    func deviceService(_ deviceService: DeviceService, onMessage message: DeviceServiceMessage, withUser user: String) {
        let position = PositionRealm()
        position.latitude = message.Position.Lat
        position.longitude = message.Position.Lon
        position.source = "\(user): \(message.DeviceId)"

        try! realm.write {
            realm.add(position)
        }

        print(realm.objects(PositionRealm.self).count)
    }
}
