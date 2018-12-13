import Foundation
import MapKit
import SnapKit
import RealmSwift

class DeviceDataViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    var realm: Realm!

    var notificationToken: NotificationToken?

    var positions: Results<GeoMessageRealm>!
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

        self.positions = realm.objects(GeoMessageRealm.self).sorted(byKeyPath: "dateEdgets", ascending: true)

        self.title = "Device Data"


        notificationToken = realm.observe { [unowned self] note, realm in
            self.drawPins()
        }
        drawPins()
    }

    private func drawPins() {
        let newPositions = (lastDrawnPosition != nil ? positions.filter("dateEdgets > %@", lastDrawnPosition!) : positions)
        for position in (newPositions    ?? positions).suffix(from: 20) {
            lastDrawnPosition = position.dateEdgets
            let annotation = DevicePositionAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
            annotation.title = "\(position.source)"
            annotation.subtitle = "\(position.dateEdgets)"
            mapView.addAnnotation(annotation)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation as? MKUserLocation != nil {
            return nil
        }
        if annotation as? DevicePositionAnnotation != nil {
            if let deviceAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: DevicePositionAnnotation.Identifier) as? DevicePositionAnnotationView {
                print("Reuse")
                deviceAnnotationView.annotation = annotation
            } else {
                print("New")
                let deviceAnnotationView = DevicePositionAnnotationView(annotation: annotation, reuseIdentifier: DevicePositionAnnotation.Identifier)
                deviceAnnotationView.markerTintColor = .orange
                return deviceAnnotationView
            }
        }
        return nil
    }
}