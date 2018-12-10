import Foundation
import Foundation


// Dog model

class DataService: NSObject {
    init(completionClosure: @escaping()->()) {
        completionClosure()
    }
    
    func addBackend(host: String, port: Int) {
    }

    func listBackends() ->Void {
    }
}
