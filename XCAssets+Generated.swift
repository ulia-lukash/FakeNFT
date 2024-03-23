// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum Basket {
    internal static let basketNoActive = ImageAsset(name: "BasketNoActive")
    internal static let sort = ImageAsset(name: "Sort")
    internal static let chevronBasket = ImageAsset(name: "chevronBasket")
    internal static let deleteCard = ImageAsset(name: "deleteCard")
    internal static let raiting0Stub = ImageAsset(name: "raiting0Stub")
    internal static let raiting1Stub = ImageAsset(name: "raiting1Stub")
    internal static let raiting2Stub = ImageAsset(name: "raiting2Stub")
    internal static let raiting3Stub = ImageAsset(name: "raiting3Stub")
    internal static let raiting4Stub = ImageAsset(name: "raiting4Stub")
    internal static let raiting5Stub = ImageAsset(name: "raiting5Stub")
    internal static let successfulPurchase = ImageAsset(name: "successfulPurchase")
  }
  internal enum Colors {
    internal static let background = ColorAsset(name: "Background")
    internal static let blackUniversal = ColorAsset(name: "Black Universal")
    internal static let black = ColorAsset(name: "Black")
    internal static let blue = ColorAsset(name: "Blue")
    internal static let gray = ColorAsset(name: "Gray")
    internal static let green = ColorAsset(name: "Green")
    internal static let lightGray = ColorAsset(name: "Light Gray")
    internal static let red = ColorAsset(name: "Red")
    internal static let whiteUniversal = ColorAsset(name: "White Universal")
    internal static let white = ColorAsset(name: "White")
    internal static let yellow = ColorAsset(name: "Yellow")
  }
  internal static let logo = ImageAsset(name: "Logo")
  internal enum Statistics {
    internal enum Avatars {
      internal static let userpickAlex = ImageAsset(name: "UserpickAlex")
      internal static let userpickEric = ImageAsset(name: "UserpickEric")
      internal static let userpickLea = ImageAsset(name: "UserpickLea")
      internal static let userpickMads = ImageAsset(name: "UserpickMads")
      internal static let userpickTimon = ImageAsset(name: "UserpickTimon")
      internal static let noAvatar = ImageAsset(name: "noAvatar")
    }
    internal enum Nfts {
      internal static let archie = ImageAsset(name: "Archie")
      internal static let emma = ImageAsset(name: "Emma")
      internal static let grace = ImageAsset(name: "Grace")
      internal static let stella = ImageAsset(name: "Stella")
      internal static let toast = ImageAsset(name: "Toast")
      internal static let zeus = ImageAsset(name: "Zeus")
      internal static let zoe = ImageAsset(name: "Zoe")
    }
    internal static let sortButton = ImageAsset(name: "sortButton")
    internal static let statisticsTabBarItem = ImageAsset(name: "statisticsTabBarItem")
  }
  internal static let yaWhite = ColorAsset(name: "YaWhite")
  internal static let backProfile = ImageAsset(name: "backProfile")
  internal static let backward = ImageAsset(name: "backward")
  internal static let backwardProfile = ImageAsset(name: "backwardProfile")
  internal static let basket = ImageAsset(name: "basket")
  internal static let basketX = ImageAsset(name: "basketX")
  internal static let chevronForward = ImageAsset(name: "chevron.forward")
  internal static let close = ImageAsset(name: "close")
  internal static let editProfile = ImageAsset(name: "editProfile")
  internal static let favouritesIcons = ImageAsset(name: "favouritesIcons")
  internal static let favouritesIconsActive = ImageAsset(name: "favouritesIconsActive")
  internal static let filledStar = ImageAsset(name: "filledStar")
  internal static let forward = ImageAsset(name: "forward")
  internal static let like = ImageAsset(name: "like")
  internal static let noLike = ImageAsset(name: "noLike")
  internal static let onboarding1 = ImageAsset(name: "onboarding-1")
  internal static let onboarding2 = ImageAsset(name: "onboarding-2")
  internal static let onboarding3 = ImageAsset(name: "onboarding-3")
  internal static let placeholderUser = ImageAsset(name: "placeholderUser")
  internal static let profilActive = ImageAsset(name: "profilActive")
  internal static let sortProfile = ImageAsset(name: "sortProfile")
  internal static let starsCell = ImageAsset(name: "starsCell")
  internal static let tablerTrashX = ImageAsset(name: "tabler_trash-x")
  internal static let tablerTrash = ImageAsset(name: "tabler_trash")
  internal static let unfilledStar = ImageAsset(name: "unfilledStar")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
