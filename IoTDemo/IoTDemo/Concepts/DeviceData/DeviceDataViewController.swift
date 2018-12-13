import Foundation
import MapKit
import SnapKit
import RealmSwift

class DeviceDataViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    var realm: Realm!

    var notificationToken: NotificationToken?

    var positions: Results<PositionRealm>!
    var lastDrawnPosition: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm(configuration: realmConfig)
        self.mapView = MKMapView()
        self.mapView.delegate = self
        self.view.addSubview(self.mapView!)
        self.mapView.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true

        self.positions = realm.objects(PositionRealm.self).sorted(byKeyPath: "createdDate", ascending: true)

        self.title = "Device Data"


        notificationToken = realm.observe { [unowned self] note, realm in
            self.drawPins()
        }
        drawPins()
    }

    private func drawPins() {
        let newPositions = (lastDrawnPosition != nil ? positions.filter("createdDate > %@", lastDrawnPosition!) : positions)
        for position in newPositions ?? positions {
            lastDrawnPosition = position.createdDate
            let annotation = DevicePositionAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
            annotation.title = "\(position.source): \(position.user)"
            annotation.subtitle = "\(position.createdDate)"
            mapView.addAnnotation(annotation)
        }

    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation as? MKUserLocation != nil {
            return nil
        }
        if annotation as? DevicePositionAnnotation != nil {
            if let deviceAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: DevicePositionAnnotation.Identifier) as? DevicePositionAnnotationView {
                deviceAnnotationView.annotation = annotation
            } else {
                return DevicePositionAnnotationView(annotation: annotation, reuseIdentifier: DevicePositionAnnotation.Identifier)
            }
        }
        return nil
    }
}