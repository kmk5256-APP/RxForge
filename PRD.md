# RxForge — PRD

**One line:** A NAPLEX readiness *diagnostic* that tells you how ready you are, per
domain, and what to study next — not another question bank.

Status: **in development, submission deliberately on hold.** See `SUBMISSION_HOLD.md`.

---

## Who it's for

Final-year PharmD students and recent graduates in the 8–12 weeks before their NAPLEX
attempt, who have already bought or downloaded question banks and still can't answer the
only question that matters: *am I ready yet, and if not, where am I weakest?*

## The problem

Question banks report raw percent-correct. Percent-correct is a bad readiness signal:

- It ignores **blueprint weight** — 90% on a 5%-weighted domain is worth far less than
  70% on a 40%-weighted one, but both show as a green bar.
- It ignores **volume** — 5 questions at 80% is noise, not evidence.
- It ignores **recency and consistency** — a strong week two months ago is not readiness
  today.

So students over-study what they're already good at and walk in mis-calibrated.

## What RxForge does

1. **Readiness Score.** A single 0–100 composite of blueprint-weighted domain accuracy,
   evidence volume, and study consistency — with an explicit confidence band that stays
   wide until you've answered enough to earn a narrow one. The score is *explainable*:
   every screen can show which of the three inputs is holding it down.
2. **Weakest-domain routing.** The app names the single highest-leverage domain to study
   next — highest blueprint weight × lowest mastery × lowest evidence — and can start
   that session in one tap.
3. **Practice that serves the diagnostic.** Quick quiz, timed block, domain focus, and
   missed-question review. Every answer is recorded as evidence with its domain and
   timestamp.
4. **Honest progress.** Domain breakdown, streak, study time, and a "what would move
   your score most" panel.

## What it does NOT do

Deliberate non-goals for 1.0 — writing them down so scope stays honest:

- **No predicted pass/fail claim.** The Readiness Score is a study-progress composite,
  not a psychometric equating to the real exam. The app says so in-product.
- **No account, no login, no server.** 100% on-device.
- **No analytics, no ads, no tracking, no data collection.** `PrivacyInfo.xcprivacy`
  declares an empty collected-data set.
- **No MPJE / state law content.** NAPLEX only in 1.0.
- **No CloudKit sync, no widgets, no spaced repetition** in 1.0 — roadmap, not scope.
- **No claim of NABP affiliation.** Blueprint domain weights are approximate and
  labeled as such everywhere they appear.

## Success

- A student can install, complete onboarding, and get a first meaningful Readiness Score
  in under 5 minutes.
- The score moves in a way the student can explain without reading a manual.
- Ships without a Guideline 4.3 finding — i.e. it is recognisably a different product
  from RxSummit and RxAce, not a reskin. See "Differentiation" below.

## Differentiation from the existing portfolio

This account already ships RxAce, RxSummit, and RxCalc. 4.3 is judged on the product, so
the difference has to be structural, not cosmetic:

| | RxSummit / RxAce | RxForge |
|---|---|---|
| Product thesis | Broad question bank; stats page bolted on | Diagnostic instrument; bank serves the score |
| Taxonomy | 6 NABP competency areas | 5 Content-Outline domains |
| Persistence | `UserDefaults` + `ObservableObject` | SwiftData `@Model` + Observation `@Observable` |
| Signature feature | Coverage meter | Readiness Score with confidence band + weakest-domain routing |
| Session model | Pick a mode, answer, see % | Every answer is timestamped evidence feeding a composite |

Honest caveat, recorded so nobody forgets it: three NAPLEX titles from one developer is
still overlap in Apple's eyes regardless of internal architecture. The mitigation is the
product thesis above plus not submitting into an open audit window.

## Stack

SwiftUI + SwiftData, iOS 17+, iPhone only, portrait. No third-party dependencies.

---

NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy.
RxForge is not affiliated with, endorsed by, or sponsored by NABP.
