import Foundation
import Alamofire

class BaseData: Decodable {
    let messageType: Int
    let deviceType: Int
}

class WaterData: Decodable {
    let messageType: Int
    let deviceType: Int
    let battery: Int
    let charging: Bool
    let waterLevel: Int
    let waterPresence: Int
    let soilHumidity: Int
}

class GeoData: Decodable {
    let messageType: Int
    let deviceType: Int
    let lat: Double
    let lng: Double
    let precision: Double?
}

class DistanceData: Decodable {
    let distance: Int
    let battery: Int
    let charging: Bool
}

enum HistoryData: Decodable {
    case waterMessage(WaterData)
    case geoMessage(GeoData)
    case distanceMessage(DistanceData)
    case baseMessage(BaseData)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .baseMessage(try container.decode(BaseData.self))
        do {
            self = .waterMessage(try container.decode(WaterData.self))
        } catch DecodingError.keyNotFound {
            do {
                self = .geoMessage(try container.decode(GeoData.self))
            } catch DecodingError.keyNotFound {
                do {
                    self = .distanceMessage(try container.decode(DistanceData.self))
                } catch DecodingError.keyNotFound {
                    print("Resort to base")
                }
            }
        }
    }
}

protocol HistoryServiceDelegate: AnyObject {
    func historyService(_ historyService: HistoryService, receivedMessages messages: [HistoryMessage])
}

class HistoryMessage: Decodable {
    let data: HistoryData
    let edgets: Int64
    let eui: String
}

class HistoryService {

    let url: URL!
    let decoder: JSONDecoder!
    var delegate: HistoryServiceDelegate?

    init(connectionString: String) {
        self.url = URL(string: connectionString)
        self.decoder = JSONDecoder()
    }

    func request(skip: Int = 0, take: Int = 10000000) {
        Alamofire.request(url).response { response in
            if let data = response.data {
                do {
                    let messages = try self.decoder.decode([HistoryMessage].self, from: data)
                    self.delegate?.historyService(self, receivedMessages: messages)
                } catch let error {
                    print(error)
                }

            } else {
                print("FAIL: No data")
            }
        }
    }
}
