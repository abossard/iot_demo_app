import Foundation
import MapKit

class SearchedAreaOverlay: MKCircle {
    var color: UIColor?

    convenience init(color: UIColor, center: CLLocationCoordinate2D, radius: Double) {
        self.init(center: center, radius: radius)
        self.color = color
    }
}
