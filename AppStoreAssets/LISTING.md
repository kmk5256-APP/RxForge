# RxForge — App Store Connect listing

Paste-ready. Every claim here is checkable against the shipped build; nothing asserts a
pass rate, a predicted score, or NABP affiliation.

---

## App record fields (creation)

| Field | Value |
|---|---|
| Platform | iOS |
| Name | `RxForge: NAPLEX Readiness` (25 / 30 chars) |
| Primary language | English (U.S.) |
| Bundle ID | `com.karankohli.rxforge` — **must be registered as an explicit App ID first** |
| SKU | `RXFORGE-001` |
| User Access | Full Access |
| Price | **$3.99** (Tier 4) — matches RxSummit. Paid up front, no in-app purchases. |

## Version 1.0 fields

**Subtitle** (29 / 30)
```
Know where you actually stand
```

**Promotional text** (161 / 170)
```
Built on the NAPLEX Content Outline effective May 1, 2025 — five content domains, weighted the way the exam weights them. Everything stays on your device.
```

**Keywords** (99 / 100 — no spaces after commas, no repeats of the app name)
```
naplex,pharmacy,pharmd,rxprep,nabp,licensure,pharmacist,exam prep,practice questions,readiness
```

**Description**
```
RxForge is a NAPLEX readiness check, not another question bank.

Question banks report raw percent-correct. That is a poor way to judge whether you are ready. It ignores how much each domain actually counts on the exam, it ignores how little you may have answered, and it treats a strong week last month the same as a strong week today. So students over-study what they are already good at.

RxForge gives you one number, and shows you exactly what is behind it.


YOUR READINESS SCORE

A 0–100 score built from three inputs, all visible in the app:

• Accuracy — weighted by how much each content domain counts on the exam
• Volume — how much you have answered, against a target for each domain
• Consistency — how many days you have studied recently

Answer five questions correctly and the score will not jump to 100. It stays deliberately cautious until there is enough evidence behind it, and it carries a visible ± range that narrows as you work. When the number is not moving, the app names which of the three inputs is the reason.


STUDY THIS NEXT

RxForge names the single domain worth your next hour — the one where exam weight, room to improve, and thin evidence line up — and starts that session in one tap. The Progress tab ranks how many points are sitting in each domain, so heavily weighted areas get the attention they deserve.


BUILT ON THE CURRENT CONTENT OUTLINE

Aligned to the five NAPLEX content domains effective May 1, 2025, at their published approximate weights:

• Foundational Knowledge for Pharmacy Practice — 25%
• Medication Use Process — 25%
• Person-Centered Assessment and Treatment Planning — 40%
• Professional Practice — 5%
• Pharmacy Management and Leadership — 5%

Practice questions are distributed in those same proportions, so a quick quiz feels like a miniature exam rather than a random pile.


PRACTICE THAT COUNTS

• Quick Quiz — 10 questions, weighted like the exam
• Timed Block — 25 questions against the clock
• Domain Focus — drill one content domain
• Missed Questions — only what you got wrong, retiring automatically once you get it right

Every question has a written explanation covering why the correct answer is correct and why the tempting wrong one is not.


PRIVATE BY DEFAULT

No account. No sign-in. No ads. No analytics. No third-party SDKs. RxForge makes no network requests at all — your answers and your score never leave your iPhone.


IMPORTANT

The Readiness Score measures your progress in this app against this app's question bank. It is not a predicted NAPLEX score, not a percentile, and not a probability of passing. No study tool can tell you whether you will pass. Practice questions are written for study and are not actual NAPLEX items.

RxForge is an educational study aid and is not medical advice.

NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy. RxForge is not affiliated with, endorsed by, or sponsored by NABP.
```

**What's New in This Version** (1.0 — leave blank if ASC does not ask for a first release)
```
First release.
```

**Support URL** — verify it loads and names the app before submitting
```
https://ai2life.org/support/rxforge
```

**Privacy Policy URL**
```
https://ai2life.org/rxforge/privacy
```

**Copyright**
```
2026 Karan Kohli
```

**Category** — Primary: Education · Secondary: Medical

---

## App Privacy answers

**Data collection: NO.** Select "No, we do not collect data from this app."

This is verifiable rather than aspirational: the Release binary references no `URLSession`,
the app has no account system, and `PrivacyInfo.xcprivacy` declares
`NSPrivacyCollectedDataTypes` empty with `NSPrivacyTracking` false. Keep the manifest and
these answers in sync if that ever changes.

## Age rating

Complete Apple's current questionnaire literally. For *Medical or Treatment Information*,
answer **Frequent** because the original pharmacy-study questions discuss medications and
treatment topics, even though RxForge is educational and does not provide patient-specific
advice. Answer **No** when asked whether the app is a regulated medical device. For the other
content descriptors, answer **None** unless the shipped build changes. Accept the rating App
Store Connect calculates; do not force or advertise an expected 4+ rating.

References: [Set an app age rating](https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating) and [Age rating values and definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions).

## Export compliance

`ITSAppUsesNonExemptEncryption` is already `false` in Info.plist, so ASC should not prompt.
If it does: no encryption beyond what Apple exempts.

---

## App Review Information → Notes

```
RxForge is a NAPLEX study aid for pharmacy students. No account or sign-in is required — tap through the three onboarding panes and the whole app is available immediately. There is no paid content, no server, and no network activity of any kind.

WHAT THE "READINESS SCORE" IS, since it is the app's main feature:

It is a study-progress composite scored 0–100 from three inputs the app displays openly — blueprint-weighted accuracy (70%), how many questions have been answered against a per-domain target (20%), and how many days the student has studied recently (10%). Accuracy is deliberately shrunk toward a neutral prior so a small number of correct answers cannot produce a high score, and the score is always shown with a ± confidence range that narrows as more questions are answered.

It is explicitly NOT presented as a predicted NAPLEX score, a percentile, or a probability of passing. The Home tab has a "What is this score?" link stating this in plain language, and the About screen (Settings → About RxForge) repeats it. We make no pass-rate or score-prediction claim anywhere in the app or the listing.

CONTENT: The five content domains and their approximate weights come from NABP's published NAPLEX Content Outline effective May 1, 2025. Topic lists within each domain are our own paraphrase, not a reproduction of NABP's outline. Practice questions are original and written for study; they are not actual exam items. The listing and the About screen both carry the NABP trademark disclaimer and state that RxForge is not affiliated with or endorsed by NABP.

PRIVACY: Nothing is collected or transmitted. All progress is stored on-device with SwiftData. The app contains no analytics, no ads, and no third-party SDKs.

REVIEWER PATH: Home shows the score and the recommended next domain. Practice → Quick Quiz runs a 10-question session; answering reveals a written explanation for each. Progress shows the per-domain breakdown. Blueprint shows the five domains at their exam weights.
```

**Contact:** Karan Kohli · the Apple ID email on the account · phone as on file
**Demo account:** not required — no login exists.
