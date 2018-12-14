import Foundation
import MapKit
import SnapKit
import RealmSwift



class DataMapViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    var realm: Realm!

    var notificationToken: NotificationToken?
    var radius = 30.0
    var radiusSlider: UISlider!
    var positions: Results<GeoMessageRealm>!
    var lastDrawnPosition: Date?
    let colorChooser = ColorChooser()


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

        self.radiusSlider = UISlider()
        self.view.addSubview(self.radiusSlider)
        self.radiusSlider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().inset(60)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(40)
        }
        self.radiusSlider.minimumValue = 1
        self.radiusSlider.maximumValue = 100
        self.radiusSlider.addTarget(self, action: #selector(resizeSearchAreas), for: .valueChanged)

        self.positions = realm.objects(GeoMessageRealm.self).sorted(byKeyPath: "dateEdgets", ascending: true)

        self.title = "Device Data"

        notificationToken = realm.observe { [unowned self] note, realm in
            self.drawPins()
        }
        drawPins()
    }

    @objc
    func resizeSearchAreas(sender: UISlider, forEvent event: UIEvent) {
        self.radius = Double(self.radiusSlider.value)
        for overlay in mapView.overlays {
            if let searchAreaOverlay = overlay as? SearchedAreaOverlay {
                mapView.removeOverlay(overlay)
                let newOverlay = SearchedAreaOverlay(color: searchAreaOverlay.color ?? .black, center: searchAreaOverlay.coordinate, radius: self.radius)
                mapView.addOverlay(newOverlay)
            }
        }
        mapView.setNeedsDisplay()
    }

    private func drawPins() {
        print("draw pins")
        let newPositions = (lastDrawnPosition != nil ? positions.filter("dateEdgets > %@", lastDrawnPosition!) : positions)
        for position in (newPositions ?? positions) {
            lastDrawnPosition = position.dateEdgets
            let annotation = DataMapPositionAnnotation(
                    radius: Int(position.precision),
                    latitude: position.latitude,
                    longitude: position.longitude,
                    color: colorChooser.getColor(forKey: position.client?.eui) ?? .black,
                    datetime: position.dateEdgets,
                    title: position.client?.eui ?? "no eui",
                    description: position.dateEdgets.description
            )
            mapView.addAnnotation(annotation)
            let searchedArea = SearchedAreaOverlay(
                    color: annotation.color ?? .black,
                    center: annotation.coordinate,
                    radius: self.radius
            )
            mapView.addOverlay(searchedArea)
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let searchAreaOverlay = overlay as? SearchedAreaOverlay {
            let circleOverlay = MKCircleRenderer(overlay: searchAreaOverlay)
            circleOverlay.strokeColor = searchAreaOverlay.color
            circleOverlay.fillColor = searchAreaOverlay.color?.withAlphaComponent(0.2)
            circleOverlay.lineWidth = 0.00001
            return circleOverlay
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation as? MKUserLocation != nil {
            return nil
        }
        if let dataMapAnnotation = annotation as? DataMapPositionAnnotation {
            if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: DataMapPositionAnnotationView.ReuseIdentifier) as? DataMapPositionAnnotationView {
                print("Reuse")
                reusedView.annotation = annotation
                reusedView.markerTintColor = dataMapAnnotation.color ?? .black
            } else {
                print("New")
                let newView = DataMapPositionAnnotationView(annotation: annotation, reuseIdentifier: DataMapPositionAnnotationView.ReuseIdentifier)
                newView.markerTintColor = dataMapAnnotation.color ?? .black
                return newView
            }
        }
        return nil
    }
}