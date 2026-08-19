# Submission hold — read before any App Store action

**Status as of 2026-08-18: RxForge is being built to be archive-ready, but must NOT be
submitted to App Review yet.** This is a deliberate decision by Karan, not an oversight.

## Why

1. **The account came off a Guideline 5.6 review suspension today.** On 2026-08-08 App
   Review rejected six apps in three minutes with an identical account-level 5.6
   Developer Code of Conduct message and a no-resubmission-before-2026-08-18 block. That
   window opened today and **eight apps went into review this morning** (Toilet Bowl,
   Slowlight, FileFlip, Hushfile, Glowwoven, Tiny Tracks Academy, Quasar Flip, + prior).

2. **The 5.6 notice carried an explicit escalation clause:** continued submissions of
   apps with "the same or similar issues" may be treated as a violation of the Apple
   Developer Program License Agreement and "may result in removal from the Apple
   Developer Program." A brand-new app landing on top of eight in-review apps on day one
   of the window is the exact shape that clause describes.

3. **There is an open Guideline 4.3 / DPLA 3.2(f) duplicate-app audit** on the portfolio.
   RxForge would be the account's fourth NAPLEX-prep title alongside RxAce (live),
   RxSummit (submitted), and RxCalc. The `PRD.md` differentiation table is a real
   argument, but it is an argument to make from a position of strength, not while an
   audit is open.

## The gate

Do not create the App ID, do not create the App Store Connect record, and do not upload
a build until **all of the following** are true:

- [ ] The eight apps currently in review have all reached a terminal state
      (Approved / Ready for Sale, or rejected-and-resolved). No open Resolution Center
      threads.
- [ ] The 4.3 / DPLA 3.2(f) duplicate audit is closed, or Apple has responded to the
      remediation on Quasar Flip / Glowwoven.
- [ ] Karan has explicitly said to proceed. Nothing in this file authorizes submission on
      its own.

## What *is* allowed right now

Everything that does not touch Apple's servers: building the app, running it on the
simulator, generating the icon and screenshots, writing the listing copy, and producing a
validated Release archive locally. Getting to "archive-ready and waiting" is the goal.

## Known: distribution signing is not resolvable yet (expected, not a defect)

`xcodebuild ... archive` succeeds, but the archive is signed:

```
Signing Identity:     "Apple Development: kok5256@icloud.com (R2HN2BB2V2)"
Provisioning Profile: "iOS Team Provisioning Profile: *"
```

That is a *development* identity on the wildcard profile, so `exportArchive` for App
Store distribution will fail — the same failure ClaimThread hit. The cause is simply that
no App ID exists for `com.karankohli.rxforge` yet, so Xcode cannot resolve a distribution
profile and falls back to Development. Registering the App ID is itself gated by this
hold, so **this resolves itself as the first step once the gate opens** — register the
App ID, open the project in Xcode so Signing & Capabilities generates the store profile,
then re-archive. Do not go hunting for a signing bug in the project; `CODE_SIGN_IDENTITY`
is deliberately unset and `CODE_SIGN_STYLE` is Automatic.

## Pre-submission checklist for when the gate opens

Learned the hard way across the last eight submissions — do not skip:

- [ ] **Support URL points at RxForge specifically.** FileFlip shipped pointing at
      PriceScout's site and Hushfile at a bare homepage; both are Guideline 1.5 failures
      that no amount of site-fixing reaches, because the reviewer opens the URL that is
      in App Store Connect. Use `ai2life.org/support/rxforge` and **load it in a browser
      first** — several sibling `*.kmk5256.chatgpt.site` support URLs returned 401.
- [ ] **Privacy Policy URL** likewise resolves and is RxForge-specific.
- [ ] Description carries the NABP trademark disclaimer and makes **no pass-rate or
      pass-prediction claim**.
- [ ] Screenshots show real app state, not mockups, and contain no pricing text.
- [ ] App Review Notes explain what the Readiness Score is and that it is not a predicted
      exam score.
- [ ] `PrivacyInfo.xcprivacy` matches the App Privacy answers in ASC (both: no collection,
      no tracking).
- [ ] Submit **alone**. One app, let it clear, then queue the next.
