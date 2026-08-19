import SwiftUI

// RxForge's palette: graphite ground, ember accent. Kept in one place so views never
// hardcode hex values (see CLAUDE.md).

extension Color {
    /// Ember — the accent used for the Readiness dial, primary actions, and selection.
    static let brandPrimary = Color(red: 0.851, green: 0.392, blue: 0.165)

    /// A hotter ember, for gradient tops and "hot" emphasis.
    static let brandHot = Color(red: 0.965, green: 0.596, blue: 0.200)

    /// Graphite — headers, the dial track, and dark surfaces.
    static let brandGraphite = Color(red: 0.145, green: 0.157, blue: 0.196)

    /// Muted graphite for secondary text on light backgrounds.
    static let brandSlate = Color(red: 0.408, green: 0.427, blue: 0.475)

    /// Card surface that adapts to light/dark.
    static let brandSurface = Color(UIColor.secondarySystemGroupedBackground)

    /// Page background that adapts to light/dark.
    static let brandBackground = Color(UIColor.systemGroupedBackground)

    // Mastery scale — used for domain bars and the dial. Deliberately not pure
    // red/green: these read as "cold metal → hot metal", matching the forge idea,
    // and stay distinguishable for the most common colour-vision deficiencies.
    static let masteryLow = Color(red: 0.616, green: 0.639, blue: 0.686)     // cold grey
    static let masteryFair = Color(red: 0.851, green: 0.522, blue: 0.196)    // warming
    static let masteryGood = Color(red: 0.882, green: 0.373, blue: 0.129)    // hot
    static let masteryStrong = Color(red: 0.180, green: 0.545, blue: 0.400)  // forged, set
}

extension Color {
    /// Colour for a 0...1 mastery value.
    static func mastery(_ value: Double) -> Color {
        switch value {
        case ..<0.50: return .masteryLow
        case ..<0.70: return .masteryFair
        case ..<0.85: return .masteryGood
        default:      return .masteryStrong
        }
    }
}

extension LinearGradient {
    /// The ember gradient used on the Home hero and the Readiness dial.
    static let ember = LinearGradient(
        colors: [.brandHot, .brandPrimary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let graphite = LinearGradient(
        colors: [Color(red: 0.176, green: 0.192, blue: 0.235),
                 Color(red: 0.110, green: 0.118, blue: 0.149)],
        startPoint: .top,
        endPoint: .bottom
    )
}
