# RxForge

**A NAPLEX readiness check, not another question bank.**

RxForge scores where a pharmacy student actually stands across the five NAPLEX content
domains — weighted the way the exam weights them — and names the one domain worth the
next hour of study.

> **Status: built and archive-ready. Submission is deliberately on hold.**
> Read [`SUBMISSION_HOLD.md`](SUBMISSION_HOLD.md) before any App Store action.

---

## The idea

Question banks report raw percent-correct, which is a poor readiness signal. It ignores
blueprint weight (90% on a 5%-weighted domain is worth far less than 70% on a
40%-weighted one), it ignores volume (5 questions at 80% is noise), and it ignores
recency. Students end up over-studying what they're already good at.

The **Readiness Score** is one 0–100 number built from three inputs, each visible in-app:

| Input | Weight | What it measures |
|---|---|---|
| Accuracy | 70% | Blueprint-weighted mastery, shrunk toward a prior so thin evidence can't spike it |
| Volume | 20% | Answers against a per-domain evidence target |
| Consistency | 10% | Distinct study days in the trailing two weeks, decaying if you go quiet |

It carries an explicit **± confidence band** that stays wide until you've earned a narrow
one, and the app names which of the three inputs is holding the score down.

**It is not a predicted NAPLEX score, a percentile, or a probability of passing**, and no
screen presents it as one.

## Content domains

Domain names and weights are from the NABP NAPLEX Content Outline effective **May 1,
2025** — the current five-domain structure, not the prior six competency areas.

| # | Domain | Weight | ~Questions |
|---|--------|--------|-----------|
| 1 | Foundational Knowledge for Pharmacy Practice | 25% | ~50 |
| 2 | Medication Use Process | 25% | ~50 |
| 3 | Person-Centered Assessment and Treatment Planning | 40% | ~80 |
| 4 | Professional Practice | 5% | ~10 |
| 5 | Pharmacy Management and Leadership | 5% | ~10 |

The bank ships 100 questions distributed in exactly those proportions (25/25/40/5/5).
Topic lists in the app are RxForge's own paraphrase of the subdomain structure, not a
reproduction of NABP's copyrighted outline.

## Features

- Readiness Score with confidence band and a plain-language explainer
- Highest-leverage domain routing — weight × room to improve × evidence gap
- Headroom projection: points available per domain at 85% mastery with evidence met
- Quick quiz, timed block, domain focus, and missed-question review (all blueprint-weighted)
- Explanation after every answer, covering why the key is right and why the trap is wrong
- Missed questions retire automatically once answered correctly
- Streak, study time, session history, per-domain detail
- 100% on-device — no account, no network, no analytics, no third-party SDK

## Build

Requires Xcode 16+ and iOS 17+. No dependencies, no package resolution.

```bash
xcodebuild -project RxForge.xcodeproj -scheme RxForge \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

The project uses a **synchronized root group** — any `.swift` file under `RxForge/` is
compiled automatically, with no pbxproj entry to add.

Regenerate the app icon:

```bash
swift Tools/generate_icon.swift
```

### DEBUG screenshot harness

`#if DEBUG` only, compiled out of Release. Drives the app into any state without taps —
used for verification and for generating App Store screenshots from real app state.

```bash
xcrun simctl launch "iPhone 17" com.karankohli.rxforge --seed --screen progress
xcrun simctl launch "iPhone 17" com.karankohli.rxforge --quiz quick --autoanswer 10
```

| Flag | Effect |
|---|---|
| `--seed` | Populate a realistic 120-answer history |
| `--fresh` | Wipe stored progress first |
| `--screen <home\|practice\|progress\|topics>` | Open that tab |
| `--quiz <quick\|timed\|domainN\|missed>` | Present a session immediately |
| `--autoanswer N` | Answer N correctly, then one incorrectly, leaving the explanation revealed |

## Project structure

```
RxForge/
├── RxForgeApp.swift        @main, ModelContainer
├── ContentView.swift       onboarding gate + TabView
├── Models/                 Domain, Question, SwiftData @Model types
├── Data/                   QuestionBank + Bank+<Domain>.swift content files
├── ViewModels/             ProgressManager, ReadinessEngine, QuizSession
├── Views/                  Home, Practice, Progress, Topics, Onboarding, Settings, Components
└── Utilities/              ColorTheme, DebugHarness
```

`ReadinessEngine` is a pure function of evidence in, numbers out — no SwiftData, no
SwiftUI — so the scoring can be reasoned about independently of the UI.

## Docs

- [`PRD.md`](PRD.md) — scope, explicit non-goals, and how this differs from RxSummit/RxAce
- [`CLAUDE.md`](CLAUDE.md) — stack, conventions, and hard constraints for contributors
- [`SUBMISSION_HOLD.md`](SUBMISSION_HOLD.md) — why submission is held and the gate to clear

## Roadmap

Expanded bank, MPJE state law packs, a readiness widget, spaced repetition, optional
CloudKit sync. All explicitly out of scope for 1.0.

---

NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy.
RxForge is not affiliated with, endorsed by, or sponsored by NABP. Questions are written
for study practice and are not actual NAPLEX items. RxForge is an educational study aid,
not medical advice.

MIT License
