import Foundation
import SwiftSignalRClient

protocol DeviceServiceDelegate: AnyObject {
    func deviceService(_ deviceService: DeviceService, onMessage: DeviceServiceMessage, withUser: String)
}

struct DeviceServiceMessageDataPosition: Decodable {
    let Lat: Double
    let Lon: Double
}

struct DeviceServiceMessage: Decodable {
    let Position: DeviceServiceMessageDataPosition
    let DeviceId: String
}

class DeviceService: HubConnectionDelegate {

    var chatHubConnection: HubConnection?
    var name = ""
    var messages: [String] = []
    var url: URL
    var decoder: JSONDecoder
    weak var delegate: DeviceServiceDelegate?

    init(connectionString: String) {
        self.url = URL(string: connectionString)!
        self.decoder = JSONDecoder()
    }

    func start() {

        chatHubConnection = HubConnectionBuilder(url: self.url)
                .withLogging(minLogLevel: .debug)
                .build()
        chatHubConnection!.delegate = self
        chatHubConnection!.on(method: "ReceiveMessage", callback: {
            args, typeConverter in
            let user = try! typeConverter.convertFromWireType(obj: args[0], targetType: String.self)
            let message = try! typeConverter.convertFromWireType(obj: args[1], targetType: String.self)
            do {
                let deviceServiceMessage = try self.decoder.decode(DeviceServiceMessage.self, from: message!.data(using: .utf8)!)
                self.delegate?.deviceService(self, onMessage: deviceServiceMessage, withUser: user!)
            } catch {
                print("Data not understood \(error)")
            }
        })
        chatHubConnection!.start()
    }

    func stop() {
        chatHubConnection?.stop()
    }


    func connectionDidOpen(hubConnection: HubConnection!) {
        print("C OPEN")
    }

    func connectionDidFailToOpen(error: Error) {
        print("C FAIL \(error)")
    }

    func connectionDidClose(error: Error?) {
        print("C FAIL 2 \(error)")
    }
}
