import Foundation
import MapKit
import SnapKit
import RealmSwift

class DeviceDataViewController: UIViewController {

    var mapView: MKMapView!
    var realm: Realm!

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
    }
}