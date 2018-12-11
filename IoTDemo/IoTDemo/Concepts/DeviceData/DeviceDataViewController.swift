import Foundation
import MapKit
import SnapKit
import RealmSwift

class DeviceDataViewController: UIViewController {

    var mapView: MKMapView!
    var realm: Realm!

    var notificationToken: NotificationToken?

    var objects: Results<PositionRealm>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm(configuration: realmConfig)
        self.mapView = MKMapView()
        self.view.addSubview(self.mapView!)
        self.mapView.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.mapView.zoomEnabled = true
        self.mapView.scrollEnabled = true

        self.objects = realm.objects(PositionRealm).sorted(byKeyPath: "createdDate", ascending: true)

        self.title = "Device Data"


        notificationToken = realm.observe { [unowned self] note, realm in
            print("Update")
        }
    }

    private func drawPins() {
    }


}