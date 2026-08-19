// Generates RxForge/Assets.xcassets/AppIcon.appiconset/AppIcon.png (1024²).
// Run from the repo root:  swift Tools/generate_icon.swift
//
// Visual identity: graphite ground + ember anvil. Deliberately unlike RxSummit's
// blue/teal summit mark — see the differentiation table in PRD.md.

import AppKit
import CoreGraphics
import UniformTypeIdentifiers

let size: CGFloat = 1024
let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
guard let ctx = CGContext(data: nil, width: Int(size), height: Int(size),
                          bitsPerComponent: 8, bytesPerRow: 0,
                          space: colorSpace,
                          bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
    fatalError("no context")
}

// MARK: - Ground

let ground = [
    CGColor(red: 0.11, green: 0.12, blue: 0.16, alpha: 1),
    CGColor(red: 0.24, green: 0.20, blue: 0.22, alpha: 1),
] as CFArray
ctx.drawLinearGradient(CGGradient(colorsSpace: colorSpace, colors: ground, locations: [0, 1])!,
                       start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: 0), options: [])

// MARK: - Anvil silhouette
//
// Drawn in arbitrary units, then fitted to a target rect so the proportions stay
// stable if the layout is ever retuned. Origin is bottom-left (CoreGraphics default).

let anvilRaw = CGMutablePath()
anvilRaw.move(to: CGPoint(x: 168, y: 596))                                  // horn tip
anvilRaw.addCurve(to: CGPoint(x: 280, y: 632),
                  control1: CGPoint(x: 210, y: 620), control2: CGPoint(x: 244, y: 631))
anvilRaw.addLine(to: CGPoint(x: 768, y: 632))                               // face → heel
anvilRaw.addLine(to: CGPoint(x: 768, y: 566))                               // heel underside
anvilRaw.addLine(to: CGPoint(x: 688, y: 566))
anvilRaw.addCurve(to: CGPoint(x: 604, y: 474),                              // sweep in to waist
                  control1: CGPoint(x: 644, y: 566), control2: CGPoint(x: 606, y: 524))
anvilRaw.addLine(to: CGPoint(x: 604, y: 404))                               // waist, right
anvilRaw.addCurve(to: CGPoint(x: 704, y: 330),                              // flare to base
                  control1: CGPoint(x: 604, y: 362), control2: CGPoint(x: 650, y: 334))
anvilRaw.addLine(to: CGPoint(x: 704, y: 268))
anvilRaw.addLine(to: CGPoint(x: 336, y: 268))                               // base
anvilRaw.addLine(to: CGPoint(x: 336, y: 330))
anvilRaw.addCurve(to: CGPoint(x: 436, y: 404),
                  control1: CGPoint(x: 390, y: 334), control2: CGPoint(x: 436, y: 362))
anvilRaw.addLine(to: CGPoint(x: 436, y: 474))                               // waist, left
anvilRaw.addCurve(to: CGPoint(x: 352, y: 566),
                  control1: CGPoint(x: 434, y: 524), control2: CGPoint(x: 396, y: 566))
anvilRaw.addLine(to: CGPoint(x: 262, y: 566))                               // face underside
anvilRaw.addCurve(to: CGPoint(x: 168, y: 596),                              // back along the horn
                  control1: CGPoint(x: 228, y: 566), control2: CGPoint(x: 190, y: 577))
anvilRaw.closeSubpath()

/// Fit `path` into `target`, preserving aspect ratio and centering.
func fit(_ path: CGPath, into target: CGRect) -> CGPath {
    let b = path.boundingBox
    let scale = min(target.width / b.width, target.height / b.height)
    var t = CGAffineTransform(translationX: target.midX - b.midX * scale,
                              y: target.midY - b.midY * scale)
        .scaledBy(x: scale, y: scale)
    return path.copy(using: &t)!
}

// Sits a little below centre, leaving the upper third for the hot strip and sparks.
let anvilRect = CGRect(x: (size - 604) / 2, y: 214, width: 604, height: 384)
let anvil = fit(anvilRaw, into: anvilRect)
let anvilBox = anvil.boundingBox

// MARK: - Ember glow, centred on the anvil face

let glow = [
    CGColor(red: 1.00, green: 0.58, blue: 0.22, alpha: 0.50),
    CGColor(red: 0.85, green: 0.28, blue: 0.08, alpha: 0.0),
] as CFArray
ctx.drawRadialGradient(CGGradient(colorsSpace: colorSpace, colors: glow, locations: [0, 1])!,
                       startCenter: CGPoint(x: size / 2, y: anvilBox.maxY - 30), startRadius: 30,
                       endCenter: CGPoint(x: size / 2, y: anvilBox.maxY - 30), endRadius: 430,
                       options: [])

// MARK: - Anvil

ctx.setShadow(offset: CGSize(width: 0, height: -12), blur: 34,
              color: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5))
ctx.setFillColor(CGColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1))
ctx.addPath(anvil)
ctx.fillPath()
ctx.setShadow(offset: .zero, blur: 0, color: nil)

// MARK: - Hot strip resting on the face

let stripWidth = anvilBox.width * 0.52
let stripHeight: CGFloat = 40
let stripRect = CGRect(x: size / 2 - stripWidth / 2 + 26,   // nudged toward the heel
                       y: anvilBox.maxY - 4,
                       width: stripWidth, height: stripHeight)

// Heat bloom under the strip, so it reads as hot metal rather than a floating pill.
let bloom = [
    CGColor(red: 1.00, green: 0.72, blue: 0.30, alpha: 0.55),
    CGColor(red: 1.00, green: 0.50, blue: 0.15, alpha: 0.0),
] as CFArray
ctx.drawRadialGradient(CGGradient(colorsSpace: colorSpace, colors: bloom, locations: [0, 1])!,
                       startCenter: CGPoint(x: stripRect.midX, y: stripRect.midY), startRadius: 10,
                       endCenter: CGPoint(x: stripRect.midX, y: stripRect.midY), endRadius: 190,
                       options: [])

let strip = [
    CGColor(red: 1.00, green: 0.93, blue: 0.55, alpha: 1),
    CGColor(red: 0.94, green: 0.38, blue: 0.10, alpha: 1),
] as CFArray
ctx.saveGState()
ctx.addPath(CGPath(roundedRect: stripRect, cornerWidth: stripHeight / 2,
                   cornerHeight: stripHeight / 2, transform: nil))
ctx.clip()
ctx.drawLinearGradient(CGGradient(colorsSpace: colorSpace, colors: strip, locations: [0, 1])!,
                       start: CGPoint(x: stripRect.minX, y: 0),
                       end: CGPoint(x: stripRect.maxX, y: 0), options: [])
ctx.restoreGState()

// MARK: - Sparks
//
// Thrown up and right off the hot end of the strip, into the darkest part of the
// ground so they stay bright. Each gets a soft halo plus a hot core.

let origin = CGPoint(x: stripRect.maxX - 30, y: stripRect.maxY)
let sparks: [(dx: CGFloat, dy: CGFloat, r: CGFloat)] = [
    (34, 74, 15), (96, 150, 11), (-26, 128, 9), (158, 96, 8.5),
    (72, 236, 8), (206, 196, 6.5), (-96, 190, 6), (140, 292, 5.5),
    (250, 108, 5), (18, 330, 4.5), (196, 350, 4),
]
for s in sparks {
    let c = CGPoint(x: origin.x + s.dx, y: origin.y + s.dy)
    let halo = [
        CGColor(red: 1.00, green: 0.72, blue: 0.28, alpha: 0.55),
        CGColor(red: 1.00, green: 0.55, blue: 0.15, alpha: 0.0),
    ] as CFArray
    ctx.drawRadialGradient(CGGradient(colorsSpace: colorSpace, colors: halo, locations: [0, 1])!,
                           startCenter: c, startRadius: 0,
                           endCenter: c, endRadius: s.r * 3.4, options: [])
    ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.78, alpha: 1))
    ctx.fillEllipse(in: CGRect(x: c.x - s.r, y: c.y - s.r, width: s.r * 2, height: s.r * 2))
}

// MARK: - Write

guard let image = ctx.makeImage() else { fatalError("no image") }
let out = URL(fileURLWithPath: "RxForge/Assets.xcassets/AppIcon.appiconset/AppIcon.png")
guard let dest = CGImageDestinationCreateWithURL(out as CFURL, UTType.png.identifier as CFString, 1, nil) else {
    fatalError("no destination")
}
CGImageDestinationAddImage(dest, image, nil)
guard CGImageDestinationFinalize(dest) else { fatalError("write failed") }
print("wrote \(out.path)")
