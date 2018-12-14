import UIKit
import SnapKit
import RealmSwift

class MainView: UIViewController, BackendViewControllerDelegate {

    var headerView: UILabel!
    var backendSelector: UIButton!
    var deviceDataButton: UIButton!

    var deviceService: DeviceService?
    var historyService: HistoryService?
    var historyDataRealmAdapter: HistoryDataRealmAdapter?
    var deviceDataRealmAdapter: DeviceDataRealmAdapter?

    var backendViewController: BackendViewController!
    var deviceDataViewController: DataMapViewController!

    var realm: Realm!
    //var sectionData = [Section(title: "Connection", cells: <#T##[UITableViewCell]##[UIKit.UITableViewCell]#>)]

    private func createHeader(title: String) -> UILabel {
        let result = UILabel()
        result.text = title
        result.backgroundColor = .red
        result.textAlignment = .center
        return result
    }
    
    private func createBackendSelector() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Choose a backend", for: .normal)
        button.addTarget(self, action: #selector(MainView.switchToBackendSelection(_:)), for: .touchUpInside)
        return button
    }

    private func createDeviceDataView() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("View Device Data", for: .normal)
        button.addTarget(self, action: #selector(MainView.switchToDeviceData(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm(configuration: realmConfig)
        self.view.backgroundColor = .white
        self.backendViewController = BackendViewController()
        self.backendViewController.delegate = self
        self.deviceDataViewController = DataMapViewController()
        self.title = "IoT Demo App"
        headerView = createHeader(title: "<select backend>")
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {(make) -> Void in
            make.top.equalToSuperview().offset(80)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        backendSelector = createBackendSelector()
        self.view.addSubview(backendSelector)
        backendSelector.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }

        deviceDataButton = createDeviceDataView()
        self.view.addSubview(deviceDataButton)
        deviceDataButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backendSelector.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(50)
        }

        self.deviceDataRealmAdapter = DeviceDataRealmAdapter()
        self.historyDataRealmAdapter = HistoryDataRealmAdapter()

        //startDeviceServiceWithLastConnection()
        //requestHistoryData()
    }
    
    override var shouldAutorotate: Bool {
        return true;
    }
    
    @objc
    func switchToBackendSelection(_ sender: UIButton!) {
        print("Button pressed")
        self.deviceService?.stop()
        self.navigationController?.pushViewController(self.backendViewController, animated: true)
    }

    @objc
    func switchToDeviceData(_ sender: UIButton!) {
        self.navigationController?.pushViewController(self.deviceDataViewController, animated: true)
    }

    func backendViewController(_ backendViewController: BackendViewController, selectConnectionString connectionString: String) {
        self.headerView.text = connectionString
        startDeviceServiceWith(connectionString: connectionString)
        requestHistoryDataWith(connectionString: connectionString)
    }

    private func getLastConnectionString() -> String? {
        let backends = realm.objects(BackendRealm.self).sorted(byKeyPath: "lastUsed", ascending: false)
        if(backends.count > 0) {
            return backends[0].connectionString
        }
        return nil
    }

    private func startDeviceServiceWithLastConnection() {
        if let connectionString = getLastConnectionString() {
            backendViewController(self.backendViewController, selectConnectionString: connectionString)
        }
    }

    private func requestHistoryData() {
        if let connectionString = getLastConnectionString() {
            requestHistoryDataWith(connectionString: connectionString)
        }
    }

    private func requestHistoryDataWith(connectionString: String) {
        self.historyService = HistoryService(connectionString: connectionString + "/api/history")
        self.historyService?.delegate = self.historyDataRealmAdapter
        self.historyService?.request()
    }

    private func startDeviceServiceWith(connectionString: String) {
        self.deviceService?.stop()
        self.deviceService = DeviceService(connectionString: connectionString + "/chathub")
        self.deviceService?.start()
        self.deviceService?.delegate = self.deviceDataRealmAdapter
    }
}

