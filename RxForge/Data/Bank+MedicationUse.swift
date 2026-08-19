import Foundation

// Domain 2 — Medication Use Process (25% of the exam).
// IDs are stable: never renumber, never reuse.

extension QuestionBank {
    static let medicationUse: [Question] = [

        Question(
            id: "M001", domain: .medicationUse, topic: "Drug names & therapeutic classes",
            difficulty: .recall,
            prompt: "The suffix '-prazole' identifies which drug class?",
            choices: ["Histamine-2 receptor antagonists", "Proton pump inhibitors",
                      "Angiotensin receptor blockers", "Statins"],
            correctIndex: 1,
            explanation: "'-prazole' marks proton pump inhibitors (omeprazole, pantoprazole, esomeprazole). H2 blockers end in '-tidine', ARBs in '-sartan', and statins in '-statin'. Stem recognition is worth drilling because it converts unfamiliar drug names into a known class."),

        Question(
            id: "M002", domain: .medicationUse, topic: "Drug names & therapeutic classes",
            difficulty: .recall,
            prompt: "Which suffix identifies a direct oral anticoagulant that inhibits factor Xa?",
            choices: ["-parin", "-xaban", "-gatran", "-grel"],
            correctIndex: 1,
            explanation: "'-xaban' denotes direct factor Xa inhibitors — apixaban, rivaroxaban, edoxaban. '-gatran' (dabigatran) is a direct thrombin inhibitor, '-parin' indicates heparins, and '-grel' indicates P2Y12 antiplatelets such as clopidogrel."),

        Question(
            id: "M003", domain: .medicationUse, topic: "Prescription regulations & boxed warnings",
            difficulty: .application,
            prompt: "Which medication carries a boxed warning for severe hepatotoxicity requiring baseline and periodic liver function monitoring, and is dispensed with a Medication Guide?",
            choices: ["Metformin", "Isotretinoin", "Amiodarone", "Lisinopril"],
            correctIndex: 2,
            explanation: "Amiodarone carries boxed warnings covering pulmonary toxicity, hepatotoxicity, and proarrhythmia, and requires baseline and periodic hepatic, thyroid, and pulmonary monitoring. Metformin's boxed warning is lactic acidosis; isotretinoin's is embryo-fetal toxicity under the iPLEDGE REMS; lisinopril's is fetal toxicity."),

        Question(
            id: "M004", domain: .medicationUse, topic: "Prescription regulations & boxed warnings",
            difficulty: .recall,
            prompt: "Under federal law, how many times may a Schedule III controlled substance prescription be refilled, and within what period?",
            choices: ["No refills permitted",
                      "Up to 5 refills within 6 months of the issue date",
                      "Up to 11 refills within 12 months",
                      "Unlimited refills within 1 year"],
            correctIndex: 1,
            explanation: "Schedule III and IV prescriptions may be refilled up to 5 times within 6 months of issue, whichever comes first. Schedule II prescriptions may not be refilled at all. Schedule V follows the prescriber's authorization. State law may be stricter, and the stricter rule governs."),

        Question(
            id: "M005", domain: .medicationUse, topic: "Prescription regulations & boxed warnings",
            difficulty: .application,
            prompt: "A REMS program with elements to assure safe use may require which of the following?",
            choices: ["Only a Medication Guide",
                      "Prescriber certification, pharmacy certification, and documented safe-use conditions",
                      "A boxed warning on the package insert only",
                      "Post-marketing surveillance reporting by the patient"],
            correctIndex: 1,
            explanation: "ETASU can require certified prescribers, certified pharmacies or settings, patient enrollment and monitoring, and documentation of safe-use conditions before dispensing. A Medication Guide alone is the least restrictive REMS element; a boxed warning is a labeling requirement and not itself a REMS."),

        Question(
            id: "M006", domain: .medicationUse, topic: "Indications & dosing regimens",
            difficulty: .application,
            prompt: "Which counseling point is essential for oral alendronate?",
            choices: ["Take with food to reduce stomach upset",
                      "Take at bedtime with a small amount of water",
                      "Take on an empty stomach with a full glass of plain water and remain upright for at least 30 minutes",
                      "Crush and mix with applesauce if swallowing is difficult"],
            correctIndex: 2,
            explanation: "Oral bisphosphonates are poorly absorbed and can cause esophageal erosion. They must be taken on waking with 6–8 oz of plain water, on an empty stomach, with no food, other drugs, or beverages for at least 30 minutes, and the patient must stay upright. Coffee, juice, and calcium all impair absorption substantially."),

        Question(
            id: "M007", domain: .medicationUse, topic: "Indications & dosing regimens",
            difficulty: .application,
            prompt: "A prescription reads 'levothyroxine 88 mcg PO daily.' Which administration instruction is correct?",
            choices: ["Take with breakfast to improve tolerability",
                      "Take on an empty stomach 30–60 minutes before breakfast, separated from calcium and iron by 4 hours",
                      "Take at bedtime with milk",
                      "Take with an antacid to reduce esophageal irritation"],
            correctIndex: 1,
            explanation: "Levothyroxine absorption is reduced by food and chelated by calcium, iron, and aluminum- or magnesium-containing antacids. Consistent timing matters as much as the timing itself, because dose titration assumes stable absorption. Milk supplies calcium and would reduce absorption."),

        Question(
            id: "M008", domain: .medicationUse, topic: "Dosage forms",
            difficulty: .application,
            prompt: "Which abbreviation appears on ISMP's list of error-prone abbreviations and should not be used?",
            choices: ["PO", "U for units", "PRN", "BID"],
            correctIndex: 1,
            explanation: "'U' for units is repeatedly misread as a zero or a four, turning 4U into 40 or 44 units — an insulin overdose. ISMP recommends spelling out 'units'. Other high-risk entries include QD, QOD, MS, and trailing zeros such as 1.0 mg."),

        Question(
            id: "M009", domain: .medicationUse, topic: "Dosage forms",
            difficulty: .recall,
            prompt: "Which insulin has no pronounced peak and is typically dosed once daily?",
            choices: ["Regular insulin", "Insulin lispro", "Insulin glargine", "NPH insulin"],
            correctIndex: 2,
            explanation: "Insulin glargine is a long-acting basal analog with a relatively flat profile over roughly 24 hours. Lispro is rapid-acting with a peak around 1 hour, regular insulin peaks at 2–3 hours, and NPH is intermediate-acting with a distinct peak at 4–10 hours."),

        Question(
            id: "M010", domain: .medicationUse, topic: "Storage, stability & disposal",
            difficulty: .application,
            prompt: "How should unopened insulin vials be stored?",
            choices: ["Frozen until the expiration date",
                      "Refrigerated at 2–8 °C until the expiration date",
                      "At room temperature indefinitely",
                      "Refrigerated, then discarded after 7 days regardless of use"],
            correctIndex: 1,
            explanation: "Unopened insulin is refrigerated at 2–8 °C and is good until the labeled expiration date. Insulin must never be frozen — freezing denatures it and the vial must be discarded. Once in use, vials and pens are kept at room temperature and discarded after a product-specific period, commonly 28 days."),

        Question(
            id: "M011", domain: .medicationUse, topic: "Storage, stability & disposal",
            difficulty: .application,
            prompt: "Which medication should be dispensed in its original manufacturer container because of moisture sensitivity?",
            choices: ["Amoxicillin capsules", "Nitroglycerin sublingual tablets",
                      "Ibuprofen tablets", "Amlodipine tablets"],
            correctIndex: 1,
            explanation: "Sublingual nitroglycerin is volatile and moisture-sensitive, and must stay in its original glass container with the original closure, away from cotton and out of pill organizers. Dabigatran capsules have a similar requirement for a different reason — they degrade rapidly once removed from the bottle or blister."),

        Question(
            id: "M012", domain: .medicationUse, topic: "Storage, stability & disposal",
            difficulty: .recall,
            prompt: "Which is the preferred method for a patient to dispose of unused opioid tablets when no take-back option is available?",
            choices: ["Keep them for future pain episodes",
                      "Flush them if the drug appears on the FDA flush list",
                      "Place them loose in the household trash",
                      "Give them to a family member with similar pain"],
            correctIndex: 1,
            explanation: "FDA maintains a short flush list of drugs — largely opioids — whose risk of accidental exposure or diversion outweighs environmental concerns when take-back is unavailable. Drug take-back programs remain first-line. Sharing a controlled substance is illegal, and loose disposal in the trash risks diversion."),

        Question(
            id: "M013", domain: .medicationUse, topic: "Immunization practice",
            difficulty: .application,
            prompt: "Which vaccine is contraindicated in a severely immunocompromised patient?",
            choices: ["Inactivated influenza vaccine", "Recombinant zoster vaccine",
                      "Live attenuated varicella vaccine", "Pneumococcal conjugate vaccine"],
            correctIndex: 2,
            explanation: "Live attenuated vaccines — varicella, MMR, live attenuated influenza, yellow fever — are contraindicated in severe immunocompromise because the attenuated organism can cause disease. Inactivated, recombinant, and conjugate vaccines are safe, though the immune response may be blunted."),

        Question(
            id: "M014", domain: .medicationUse, topic: "Immunization practice",
            difficulty: .recall,
            prompt: "What is the first-line treatment for anaphylaxis following a vaccination?",
            choices: ["Oral diphenhydramine 50 mg",
                      "Intramuscular epinephrine into the anterolateral thigh",
                      "Intravenous methylprednisolone",
                      "Nebulized albuterol"],
            correctIndex: 1,
            explanation: "Intramuscular epinephrine in the vastus lateralis is first-line and must not be delayed; the adult dose is typically 0.3–0.5 mg of the 1 mg/mL concentration, repeatable every 5–15 minutes. Antihistamines and corticosteroids are adjuncts that do nothing for airway or cardiovascular collapse."),

        Question(
            id: "M015", domain: .medicationUse, topic: "Immunization practice",
            difficulty: .application,
            prompt: "Which storage condition is correct for most refrigerated vaccines?",
            choices: ["−50 °C to −15 °C freezer",
                      "2 °C to 8 °C with continuous temperature monitoring",
                      "Room temperature, 20 °C to 25 °C",
                      "Any temperature provided the vaccine is used within 24 hours"],
            correctIndex: 1,
            explanation: "Most refrigerated vaccines are stored at 2–8 °C with a calibrated continuous temperature-monitoring device and documented readings. Varicella-containing vaccines are the notable frozen exception. Excursions must be recorded and the manufacturer contacted before the vaccine is used."),

        Question(
            id: "M016", domain: .medicationUse, topic: "Therapeutic substitution & biosimilars",
            difficulty: .analysis,
            prompt: "What distinguishes an interchangeable biosimilar from a biosimilar that is not designated interchangeable?",
            choices: ["An interchangeable product has an identical amino acid sequence",
                      "An interchangeable product may be substituted at the pharmacy without prescriber intervention, subject to state law",
                      "An interchangeable product requires no clinical data",
                      "Only interchangeable products may use the reference product's name"],
            correctIndex: 1,
            explanation: "Interchangeability is a regulatory designation permitting pharmacy-level substitution without contacting the prescriber, where state law allows. It requires additional data — typically switching studies — beyond biosimilarity. All biosimilars are highly similar to the reference product with no clinically meaningful differences, but only interchangeable ones can be swapped at the counter."),

        Question(
            id: "M017", domain: .medicationUse, topic: "Therapeutic substitution & biosimilars",
            difficulty: .application,
            prompt: "A prescription for a brand-name drug is presented and the state permits generic substitution. Which is required before substituting?",
            choices: ["Nothing; substitution is always automatic",
                      "The generic must be therapeutically equivalent, commonly an 'A' rating in the Orange Book, and the prescriber must not have prohibited substitution",
                      "The patient must obtain a new prescription",
                      "The prescriber must be contacted for every substitution"],
            correctIndex: 1,
            explanation: "Substitution requires a therapeutically equivalent product — an A-rated code in the Orange Book — and the absence of a 'dispense as written' instruction. B-rated products are not considered therapeutically equivalent and may not be substituted. Patient notification requirements vary by state."),

        Question(
            id: "M018", domain: .medicationUse, topic: "Indications & dosing regimens",
            difficulty: .analysis,
            prompt: "A prescription reads 'warfarin 5 mg, take 1 tablet PO daily, #30, 3 refills.' Which element makes this prescription problematic?",
            choices: ["Warfarin cannot be refilled",
                      "The quantity exceeds the federal limit",
                      "Nothing is inherently invalid, but 90 days of warfarin without INR monitoring is clinically inappropriate",
                      "Warfarin requires a Schedule II prescription"],
            correctIndex: 2,
            explanation: "Warfarin is not a controlled substance and can legally carry refills. The problem is clinical: warfarin has a narrow therapeutic index and requires regular INR monitoring with dose adjustment, so dispensing 120 days' supply without a monitoring plan invites harm. This is a case where the legally valid prescription still warrants a call."),

        Question(
            id: "M019", domain: .medicationUse, topic: "Prescription regulations & boxed warnings",
            difficulty: .application,
            prompt: "Which information is legally required on the label of a dispensed controlled substance in Schedule II–IV?",
            choices: ["The prescriber's DEA number",
                      "A transfer warning stating it is unlawful to transfer the drug to any person other than the patient",
                      "The wholesale acquisition cost",
                      "The manufacturer's lot number"],
            correctIndex: 1,
            explanation: "Federal law requires the transfer warning on dispensed Schedule II–IV controlled substances. The DEA number belongs on the prescription record, not necessarily the patient label, and lot numbers and pricing are not federally required label elements."),

        Question(
            id: "M020", domain: .medicationUse, topic: "Dosage forms",
            difficulty: .application,
            prompt: "Which dosage form modification is acceptable?",
            choices: ["Crushing extended-release metoprolol succinate",
                      "Splitting a scored immediate-release lisinopril tablet",
                      "Opening an enteric-coated aspirin tablet and mixing with food",
                      "Crushing sublingual nitroglycerin for tube administration"],
            correctIndex: 1,
            explanation: "Scored immediate-release tablets are designed to be split. Crushing extended-release products can dump the full dose at once, defeating the delivery system and risking toxicity; destroying an enteric coating exposes the drug to acid or the stomach to the drug; and sublingual tablets depend on buccal absorption that tube administration bypasses."),

        Question(
            id: "M021", domain: .medicationUse, topic: "Storage, stability & disposal",
            difficulty: .application,
            prompt: "A reconstituted amoxicillin suspension is dispensed. What is the standard beyond-use guidance?",
            choices: ["Store at room temperature for 30 days",
                      "Refrigerate and discard after 14 days",
                      "Refrigerate and discard after 90 days",
                      "Freeze and thaw as needed for 6 months"],
            correctIndex: 1,
            explanation: "Reconstituted amoxicillin suspension is typically refrigerated and discarded after 14 days. The general principle matters more than the specific number: reconstitution starts a much shorter clock than the dry powder's expiration date, and the beyond-use date must be written on the label."),

        Question(
            id: "M022", domain: .medicationUse, topic: "Drug names & therapeutic classes",
            difficulty: .recall,
            prompt: "Which pair represents a look-alike/sound-alike error risk?",
            choices: ["Metformin and metronidazole", "Aspirin and acetaminophen",
                      "Warfarin and heparin", "Insulin and metformin"],
            correctIndex: 0,
            explanation: "Metformin and metronidazole share a prefix and length and are a documented confusion pair, as are hydralazine/hydroxyzine and clonidine/klonopin. Tall man lettering — metFORMIN versus metroNIDAZOLE — is a standard mitigation. The other pairs differ enough in appearance to be low risk."),

        Question(
            id: "M023", domain: .medicationUse, topic: "Indications & dosing regimens",
            difficulty: .application,
            prompt: "Which counseling point applies to oral tetracycline or doxycycline?",
            choices: ["Take with dairy products to improve absorption",
                      "Avoid dairy, antacids, and iron near the dose, and use sun protection",
                      "Take at bedtime lying flat",
                      "Double the dose if a dose is missed"],
            correctIndex: 1,
            explanation: "Tetracyclines chelate divalent and trivalent cations, so calcium, magnesium, aluminum, and iron markedly reduce absorption and should be separated from the dose. They also cause photosensitivity, and doxycycline should be taken with adequate water while remaining upright to prevent esophageal irritation."),

        Question(
            id: "M024", domain: .medicationUse, topic: "Prescription regulations & boxed warnings",
            difficulty: .recall,
            prompt: "Which DEA form is used to order Schedule II controlled substances?",
            choices: ["DEA Form 41", "DEA Form 106", "DEA Form 222 or its electronic equivalent (CSOS)", "DEA Form 224"],
            correctIndex: 2,
            explanation: "DEA Form 222, or CSOS electronically, is required to order Schedule I and II substances. Form 41 documents destruction of controlled substances, Form 106 reports theft or significant loss, and Form 224 is the application for a pharmacy's DEA registration."),

        Question(
            id: "M025", domain: .medicationUse, topic: "Dosage forms",
            difficulty: .application,
            prompt: "A patient cannot swallow tablets and needs an alternative to extended-release metformin. What is the most appropriate action?",
            choices: ["Crush the extended-release tablet into applesauce",
                      "Contact the prescriber about switching to immediate-release metformin given in divided doses",
                      "Dissolve the extended-release tablet in warm water",
                      "Halve the extended-release tablet"],
            correctIndex: 1,
            explanation: "The correct move is to change the product, not defeat it. Immediate-release metformin dosed two or three times daily is a therapeutically appropriate alternative that can be taken as a smaller tablet or a solution. Crushing, dissolving, or splitting an extended-release matrix risks dose dumping and GI intolerance.")
    ]
}
