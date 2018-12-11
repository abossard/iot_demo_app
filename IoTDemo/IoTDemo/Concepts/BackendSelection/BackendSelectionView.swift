import Foundation
import UIKit
import SnapKit
import RealmSwift

class BackendTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BackendTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}


class BackendViewController: UITableViewController {
    var notificationToken: NotificationToken?
    var realm: Realm!

    var objects: Results<BackendRealm>!

    private func createTable() -> UITableView {
        let table = UITableView()
        return table
    }

    private func setupUI() {
        self.title = "Select a Backend..."
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(addItem(_:)))
        self.tableView.register(BackendTableViewCell.self, forCellReuseIdentifier: BackendTableViewCell.reuseIdentifier)
    }

    private func setupRealm() {
        realm = try! Realm()

        notificationToken = realm.observe { [unowned self] note, realm in
            self.tableView.reloadData()
        }

        objects = realm.objects(BackendRealm.self).sorted(byKeyPath: "lastUsed", ascending: false)
    }

    override func viewDidLoad() {
        setupUI()
        setupRealm()

        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackendTableViewCell.reuseIdentifier, for: indexPath) as? BackendTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let backend = objects[indexPath.row]
        cell.textLabel?.text = backend.connectionString
        cell.detailTextLabel?.text = backend.lastUsed.description
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(objects[indexPath.row])
            }
        }
    }


    @objc
    func addItem(_ sender: UIBarButtonItem) {
        print("Add Backend")
        try! realm.write {
            realm.create(BackendRealm.self, value: ["google.com \(Date())", Date()])
        }
    }
}
