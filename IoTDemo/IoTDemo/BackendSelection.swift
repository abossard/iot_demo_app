import Foundation
import UIKit
import SnapKit


struct Backend {
    let host: String
    let port: Int
    let lastUsed: Date

    var description: String {
        return "\(self.host):\(self.port)"
    }
}

class BackendAPI {
    static func getBackends() -> [Backend] {
        let data = [
            Backend(host: "google.com", port: 123, lastUsed: Date())
        ]
        return data
    }
    static func addBackend(backend: Backend) -> Void {
        print("Added backend")
    }
}

class BackendViewController: UIViewController {
    private let backends = BackendAPI.getBackends()
    var backendsTableView: UIView!
    
    private func createTable() -> UIView {
        let table = UITableView()
        return table
    }
    
    override func viewDidLoad() {
        self.title = "Select a Backend..."
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(addItem(_:)))
       
        backendsTableView = createTable()
        view.addSubview(backendsTableView)
        backendsTableView.snp.makeConstraints {(make)->Void in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalTo(self.view)
        }
        
    }
    
    @objc
    func addItem(_ sender: UIBarButtonItem) {
        print("Add Backend")
    }
}
