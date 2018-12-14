import Foundation
import MapKit


class DataMapPositionAnnotation: NSObject, MKAnnotation {
    init(
            radius: Int,
            latitude: Double,
            longitude: Double,
            color: UIColor,
            datetime: Date,
            title: String,
            description: String
    ) {
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = description
        self.radius = radius
        self.color = color
        self.datetime = datetime
    }

    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var title: String? = nil
    private(set) var subtitle: String? = nil
    private(set) var color: UIColor? = nil
    private(set) var radius: Int? = nil
    private(set) var datetime: Date? = nil


}
