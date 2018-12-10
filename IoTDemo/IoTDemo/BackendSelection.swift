import Foundation
import UIKit
import SnapKit

class BackendTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BackendTableViewCell"
}

class BackendViewController: UIViewController, UITableViewDataSource {
    var backendsTableView: UIView!

    private func createTable() -> UIView {
        let table = UITableView()
        return table
    }

    private func refreshData() {
        //backends = DataService.singleton!.listBackends()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackendTableViewCell.reuseIdentifier, for: indexPath) as? BackendTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        //let backend = backends[indexPath.row]
        cell.textLabel?.text = "1"
        cell.detailTextLabel?.text = "2"
        return cell
    }
    
    @objc
    func addItem(_ sender: UIBarButtonItem) {
        print("Add Backend")
        //DataService.singleton?.addBackend(host: "google.com", port: 1234)
    }


}
