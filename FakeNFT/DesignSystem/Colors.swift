import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    private static let yaBlackLight = UIColor(hexString: "1A1B22")
    private static let yaBlackDark = UIColor(hexString: "#FFFFFF")
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")
    private static let yaWhiteLight = UIColor(hexString: "#FFFFFF")
    private static let yaWhiteDark = UIColor(hexString: "#2C2C2E")
    
    // Background Colors
    static let backgroundUniversal = UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.5)
    
    // Universal Colors
    static let grayUniversal = UIColor(hexString: "#625C5C")
    static let redUniversal = UIColor(hexString: "#F56B6C")
    static let greenUniversal = UIColor(hexString: "#1C9F00")
    static let blueUniversal = UIColor(hexString: "#0A84FF")
    static let blackUniversal = UIColor(hexString: "#1A1B22")
    static let whiteUniversal = UIColor(hexString: "#FFFFFF")
    static let yellowUniversal = UIColor(hexString: "#FEEF0D")
    
    //Light || Dark Mode
    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayLight
        : .yaLightGrayDark
    }

    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
    
    static let whiteModeThemes = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaWhiteDark
        : .yaWhiteLight
        
    }
}
