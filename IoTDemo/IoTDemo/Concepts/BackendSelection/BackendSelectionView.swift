import Foundation
import UIKit
import RealmSwift
import Eureka

protocol BackendViewControllerDelegate: AnyObject {
    func backendViewController(_ backendViewController: BackendViewController, selectConnectionString: String)
}

class BackendTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BackendTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

class BackendViewController: UITableViewController, AddBackendViewControllerDelegate {
    var notificationToken: NotificationToken?
    var realm: Realm!
    var addBackendViewController: AddBackendViewController

    weak var delegate: BackendViewControllerDelegate?

    var objects: Results<BackendRealm>!

    init() {
        addBackendViewController = AddBackendViewController(style: .plain)
        super.init(style: .plain)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    private func createTable() -> UITableView {
        let table = UITableView()
        return table
    }

    private func setupUI() {
        self.title = "Select a Backend..."
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(addItem(_:)))
        self.tableView.register(BackendTableViewCell.self, forCellReuseIdentifier: BackendTableViewCell.reuseIdentifier)
        self.addBackendViewController = AddBackendViewController()
        self.addBackendViewController.delegate = self
    }

    private func setupRealm() {
        realm = try! Realm(configuration: realmConfig)
        objects = realm.objects(BackendRealm.self).sorted(byKeyPath: "lastUsed", ascending: false)

        notificationToken = realm.observe { [unowned self] note, realm in
            self.tableView.reloadData()
        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backend = objects[indexPath.row]
        try! realm.write {
            backend.lastUsed = Date()
        }
        delegate?.backendViewController(self, selectConnectionString: backend.connectionString)
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    func addItem(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(self.addBackendViewController, animated: true)
    }

    func addBackendViewController(_ addBackendViewController: AddBackendViewController, connectionString: URL) {
        try! realm.write {
            realm.create(BackendRealm.self, value: [connectionString.absoluteString, Date()], update: true)
        }
    }
}

protocol AddBackendViewControllerDelegate: AnyObject {
    func addBackendViewController(_ addBackendViewController: AddBackendViewController, connectionString: URL)
}

class AddBackendViewController: FormViewController {

    weak var delegate: AddBackendViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Backend"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.save, target: self, action: #selector(addBackend(_:)))

        form +++ Section("Add connection string")
        <<< URLRow(){
            $0.title = "URL"
            $0.tag = "url"
        }
    }

    @objc func addBackend(_ sender: UIBarButtonItem) {
        let row: URLRow? = form.rowBy(tag: "url")
        self.delegate?.addBackendViewController(self, connectionString: row!.value!)
        self.navigationController?.popViewController(animated: true)
    }
}
