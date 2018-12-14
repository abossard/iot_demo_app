import Foundation
import UIKit

class ColorChooser {
    var availableColors:[UIColor] = [.green, .blue, .orange, .yellow, .brown, .purple, .red, .white]
    var lastUsedColorIndex = 0
    var keyedIndices: [String: Int] = [:]

    init() {

    }

    func getColor(forKey key: String?) -> UIColor? {
        guard let key = key else {
            return nil
        }
        if let colorIndex = keyedIndices[key] {
            return availableColors[colorIndex]
        } else {
            let newIndex = getNextIndex()
            keyedIndices[key] = newIndex
            return availableColors[newIndex]
        }
    }

    private func getNextIndex() -> Int {
        if lastUsedColorIndex == availableColors.count - 1 {
            lastUsedColorIndex = 0
        } else {
            lastUsedColorIndex += 1
        }
        return lastUsedColorIndex
    }


}
