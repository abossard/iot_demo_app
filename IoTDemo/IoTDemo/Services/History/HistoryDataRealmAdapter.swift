import Foundation
import RealmSwift

class HistoryDataRealmAdapter: HistoryServiceDelegate {
    var realm: Realm!

    init() {
        realm = try! Realm(configuration: realmConfig)
    }

    func historyService(_ historyService: HistoryService, receivedMessages messages: [HistoryMessage]) {
        var waterMessages:[WaterMessageRealm] = []
        var geoMessages:[GeoMessageRealm] = []
        for message in messages {
            let networkDevice = NetworkDeviceRealm()
            networkDevice.eui = message.eui
            switch message.data {
            case .geoMessage(let geoMessage):
                let geoMessageRealm = GeoMessageRealm()
                geoMessageRealm.latitude = geoMessage.lat
                geoMessageRealm.longitude = geoMessage.lng
                geoMessageRealm.precision = geoMessage.precision ?? 0
                geoMessageRealm.edgets = message.edgets
                geoMessageRealm.dateEdgets = Date(timeIntervalSince1970: TimeInterval(message.edgets / 1000))
                geoMessageRealm.source = "\(geoMessage.deviceType):\(geoMessage.messageType)"
                geoMessageRealm.client = networkDevice
                geoMessages.append(geoMessageRealm)
            case .waterMessage(let waterMessage):
                let waterMessageRealm = WaterMessageRealm()
                waterMessageRealm.soilHumidity = waterMessage.soilHumidity
                waterMessageRealm.waterLevel = waterMessage.waterLevel
                waterMessageRealm.waterPresence = waterMessage.waterPresence
                waterMessageRealm.edgets = message.edgets
                waterMessageRealm.dateEdgets = Date(timeIntervalSince1970: TimeInterval(message.edgets / 1000))
                waterMessageRealm.source = "\(waterMessage.deviceType):\(waterMessage.messageType)"
                waterMessageRealm.client = networkDevice
                waterMessages.append(waterMessageRealm)
            case .baseMessage, .distanceMessage:
                continue
            }
        }
        try! realm.write {
            realm.add(waterMessages, update: true)
            realm.add(geoMessages, update: true)
        }
        print(realm.objects(GeoMessageRealm.self).count)
        print(realm.objects(WaterMessageRealm.self).count)
        print(realm.objects(HistoryMessageRealm.self).count)
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
