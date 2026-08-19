# RxForge

**Forge your way to passing the NAPLEX.**

RxForge is a beautiful, native iOS study companion built specifically for pharmacy students and graduates preparing for the North American Pharmacist Licensure Examination.

Clean clinical design. Domain-weighted practice. Real progress tracking. No fluff.

---

## Why RxForge?

- **Readiness Score** — A smart composite of domain accuracy, study volume, and consistency
- **Aligned to the current NAPLEX blueprint** (post-2025 Content Outline)
- Quick quizzes, timed blocks, domain focus, and missed-question review
- Detailed explanations after every question
- Streaks, study time, and clear weak-area visibility
- 100% offline and private — all data stays on your device

## Content Domains Covered

| Domain | Approx. Weight |
|--------|----------------|
| Foundational Knowledge for Pharmacy Practice | ~25% |
| Medication Use Process | ~25% |
| Person-Centered Assessment & Treatment Planning | ~40% |
| Professional Practice | ~5% |
| Pharmacy Management & Leadership | ~5% |

## Features at a Glance

- Modern SwiftUI + SwiftData
- Beautiful, natural iOS design language
- Progress dashboard with domain breakdowns
- Smart review of questions you miss
- Daily streak tracking
- Clean onboarding experience

## Getting Started (Xcode)

1. Clone this repository
2. Create a new iOS App project in Xcode (SwiftUI + SwiftData)
3. Name the product **RxForge**
4. Delete the default App and ContentView files Xcode creates
5. Drag the entire `RxForge` folder into your project
6. Build and run

## Project Structure

```
RxForge/
├── RxForgeApp.swift
├── ContentView.swift
├── Models/
├── Data/          ← Question bank lives here
├── ViewModels/
├── Views/
│   ├── Home/
│   ├── Practice/
│   ├── Progress/
│   ├── Topics/
│   └── Onboarding/
└── Utilities/
```

## Roadmap Ideas

- Expand the question bank significantly
- Add MPJE state law packs
- Widgets for readiness score
- Spaced repetition algorithm
- Optional CloudKit sync

---

**RxForge** — Built for pharmacy students who want a focused, native tool that actually helps them pass.

NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy. This project is not affiliated with or endorsed by NABP.

MIT License
