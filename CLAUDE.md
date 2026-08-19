# RxForge — project instructions

NAPLEX readiness diagnostic. Read `PRD.md` for scope and non-goals.
**Submission is on hold — read `SUBMISSION_HOLD.md` before any App Store action.**

## Stack

- SwiftUI + SwiftData, Swift 5, iOS 17.0 minimum
- Observation framework (`@Observable`), not `ObservableObject`
- iPhone only (`TARGETED_DEVICE_FAMILY = 1`), portrait only
- No third-party dependencies, no network calls, no analytics

## Project shape

`RxForge.xcodeproj` uses a **synchronized root group** (`objectVersion = 77`). Any
`.swift` file placed anywhere under `RxForge/` is compiled automatically — there is no
file list in the pbxproj to update. Never hand-add build-file entries.

```
RxForge/
├── RxForgeApp.swift        @main, ModelContainer
├── ContentView.swift       onboarding gate + TabView
├── Models/                 Domain, Question, SwiftData @Model types
├── Data/                   QuestionBank
├── ViewModels/             ProgressManager, ReadinessEngine, QuizSession
├── Views/                  Home, Practice, Progress, Topics, Onboarding, Components
└── Utilities/              ColorTheme, Formatters
```

## Commands

Build for simulator:
```
xcodebuild -project RxForge.xcodeproj -scheme RxForge -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Release archive:
```
xcodebuild -project RxForge.xcodeproj -scheme RxForge -destination 'generic/platform=iOS' -configuration Release archive -archivePath build/RxForge.xcarchive
```

There are no unit tests yet. If you add a test target, add its command here.

## Identity

- Bundle ID `com.karankohli.rxforge`
- Team `44RB5ZX6TQ`
- Display name `RxForge`
- Ships as **Karan Kohli**

## Hard constraints

- **No pass/fail prediction.** The Readiness Score is a study-progress composite. Never
  label it a predicted score, a percentile, or a probability of passing. Every surface
  that shows it must be able to explain what feeds it.
- **Blueprint weights are approximate** and must be labeled that way wherever shown.
- **No NABP affiliation implied.** Keep the trademark disclaimer in About and in the
  App Store description.
- **Nothing leaves the device.** No `URLSession`, no third-party SDK, no `UIActivity`
  export of user data in 1.0. `PrivacyInfo.xcprivacy` declares an empty
  `NSPrivacyCollectedDataTypes` and `NSPrivacyTracking = false` — if that ever stops
  being true, the manifest changes in the same commit.
- **Do not copy code from RxSummit, RxAce, or RxCalc.** Shared *tooling* (icon scripts,
  build scripts) is fine; shared views, models, or question content are a Guideline 4.3
  problem. See the differentiation table in `PRD.md`.
- **No `Ai2LifeBranding` / `Ai2LifeBar` view modifier.** That shared top bar is part of
  what got the account a 5.6 review suspension across six apps.

## Conventions

- Colors come from `Utilities/ColorTheme.swift` (`Color.brandPrimary` etc.). Do not
  hardcode hex values in views.
- Domain weights live in one place: `Models/Domain.swift`. Nothing else may define them.
- Question content lives only in `Data/`. Views never inline question text.
