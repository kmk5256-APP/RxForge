import SwiftUI

extension Color {
    // Brand
    static let brandPrimary = Color(red: 0.18, green: 0.42, blue: 0.78)   // Calm clinical blue
    static let brandSecondary = Color(red: 0.13, green: 0.65, blue: 0.60) // Teal
    static let brandAccent = Color(red: 0.95, green: 0.55, blue: 0.20)    // Warm accent
    
    // Semantic
    static let success = Color(red: 0.20, green: 0.68, blue: 0.40)
    static let warning = Color(red: 0.95, green: 0.68, blue: 0.15)
    static let danger  = Color(red: 0.90, green: 0.30, blue: 0.30)
    
    // Domain colors
    static let domainBlue   = Color(red: 0.23, green: 0.51, blue: 0.96)
    static let domainTeal   = Color(red: 0.13, green: 0.70, blue: 0.67)
    static let domainIndigo = Color(red: 0.40, green: 0.31, blue: 0.85)
    static let domainOrange = Color(red: 0.96, green: 0.55, blue: 0.18)
    static let domainPurple = Color(red: 0.61, green: 0.35, blue: 0.85)
    
    static func domainColor(for domain: ContentDomain) -> Color {
        switch domain {
        case .foundational:   return .domainBlue
        case .medicationUse:  return .domainTeal
        case .personCentered: return .domainIndigo
        case .professional:   return .domainOrange
        case .management:     return .domainPurple
        }
    }
}

struct AppTheme {
    static let cornerRadius: CGFloat = 16
    static let smallCorner: CGFloat = 12
}
