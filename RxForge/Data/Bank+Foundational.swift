import Foundation

// Domain 1 — Foundational Knowledge for Pharmacy Practice (25% of the exam).
// IDs are stable: never renumber, never reuse.

extension QuestionBank {
    static let foundational: [Question] = [

        Question(
            id: "F001", domain: .foundational, topic: "Pharmacokinetics & pharmacodynamics",
            difficulty: .application,
            prompt: "A drug follows first-order elimination with a half-life of 8 hours. Approximately how long until it reaches steady state on a fixed maintenance regimen?",
            choices: ["8 hours", "16 hours", "40 hours", "80 hours"],
            correctIndex: 2,
            explanation: "Steady state is reached after roughly 4–5 half-lives regardless of dose or dosing interval. 5 × 8 h = 40 hours. 16 hours is only 2 half-lives (~75% of steady state). Loading doses shorten the time to a therapeutic concentration but do not change the time to steady state."),

        Question(
            id: "F002", domain: .foundational, topic: "Pharmacokinetics & pharmacodynamics",
            difficulty: .analysis,
            prompt: "Which parameter determines the loading dose of a drug?",
            choices: ["Clearance", "Volume of distribution", "Half-life", "Bioavailability fraction only"],
            correctIndex: 1,
            explanation: "Loading dose = (Vd × target concentration) / F. It depends on volume of distribution, because the goal is to fill the space the drug distributes into. Clearance drives the maintenance dose, not the loading dose. Half-life is derived from both Vd and clearance."),

        Question(
            id: "F003", domain: .foundational, topic: "Pharmacokinetics & pharmacodynamics",
            difficulty: .recall,
            prompt: "Zero-order elimination is best described as:",
            choices: ["A constant fraction of drug eliminated per unit time",
                      "A constant amount of drug eliminated per unit time",
                      "Elimination proportional to plasma concentration",
                      "Elimination that stops at steady state"],
            correctIndex: 1,
            explanation: "Zero-order (saturable) elimination removes a fixed amount per unit time, so half-life increases as concentration rises. Phenytoin, ethanol, and high-dose aspirin behave this way. A constant fraction per unit time describes first-order elimination."),

        Question(
            id: "F004", domain: .foundational, topic: "Pharmacology",
            difficulty: .recall,
            prompt: "Which receptor does albuterol primarily stimulate?",
            choices: ["Beta-1 adrenergic", "Beta-2 adrenergic", "Alpha-1 adrenergic", "Muscarinic M3"],
            correctIndex: 1,
            explanation: "Albuterol is a selective beta-2 agonist, producing bronchial smooth muscle relaxation. Its common adverse effects — tremor, tachycardia, hypokalemia — reflect beta-2 activity elsewhere plus loss of selectivity at higher doses. M3 blockade (ipratropium) also bronchodilates but by a different mechanism."),

        Question(
            id: "F005", domain: .foundational, topic: "Pharmacology",
            difficulty: .application,
            prompt: "A patient on warfarin starts rifampin. What is the expected effect on INR?",
            choices: ["INR rises because rifampin inhibits CYP2C9",
                      "INR falls because rifampin induces CYP2C9 and CYP3A4",
                      "No change; rifampin does not affect warfarin",
                      "INR rises because rifampin displaces warfarin from albumin"],
            correctIndex: 1,
            explanation: "Rifampin is a potent inducer of CYP2C9, CYP3A4, and P-glycoprotein. Induction accelerates warfarin metabolism, lowering INR and raising clot risk — the warfarin dose usually must increase. Induction takes days to develop and days to dissipate, so the INR must also be rechecked when rifampin stops."),

        Question(
            id: "F006", domain: .foundational, topic: "Pharmacology",
            difficulty: .analysis,
            prompt: "Which statement best distinguishes a competitive antagonist from a non-competitive antagonist?",
            choices: ["A competitive antagonist lowers the maximal response; a non-competitive antagonist does not",
                      "A competitive antagonist can be overcome by increasing agonist concentration; a non-competitive antagonist cannot",
                      "A competitive antagonist binds irreversibly; a non-competitive antagonist binds reversibly",
                      "Only non-competitive antagonists shift the dose–response curve"],
            correctIndex: 1,
            explanation: "Competitive antagonists bind the same site as the agonist, shifting the dose–response curve right while preserving maximal effect — enough agonist outcompetes them. Non-competitive antagonists reduce the maximal achievable response and cannot be surmounted by more agonist. The first option reverses the two."),

        Question(
            id: "F007", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .application,
            prompt: "How many grams of dextrose are in 500 mL of D5W?",
            choices: ["5 g", "25 g", "50 g", "2.5 g"],
            correctIndex: 1,
            explanation: "D5W is 5% w/v — 5 g per 100 mL. 500 mL × (5 g / 100 mL) = 25 g. A frequent slip is reading 5% as 5 g per bag regardless of volume."),

        Question(
            id: "F008", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .application,
            prompt: "An order reads heparin 25,000 units in 250 mL to infuse at 1,000 units/hour. What is the pump rate in mL/hour?",
            choices: ["4 mL/hr", "10 mL/hr", "25 mL/hr", "40 mL/hr"],
            correctIndex: 1,
            explanation: "Concentration is 25,000 units / 250 mL = 100 units/mL. 1,000 units/hr ÷ 100 units/mL = 10 mL/hr."),

        Question(
            id: "F009", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .analysis,
            prompt: "How much of a 70% dextrose stock and how much sterile water are needed to prepare 1,000 mL of 25% dextrose?",
            choices: ["357 mL stock + 643 mL water",
                      "250 mL stock + 750 mL water",
                      "500 mL stock + 500 mL water",
                      "700 mL stock + 300 mL water"],
            correctIndex: 0,
            explanation: "Use C1V1 = C2V2: (70%)(V1) = (25%)(1,000 mL), so V1 = 25,000/70 ≈ 357 mL of stock, and 1,000 − 357 = 643 mL of diluent. Alligation gives the same answer: 25 parts dextrose to 45 parts water out of 70 total."),

        Question(
            id: "F010", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .application,
            prompt: "A patient weighs 176 lb. The dose is 1.5 mg/kg. What is the dose, rounded to the nearest milligram?",
            choices: ["80 mg", "120 mg", "264 mg", "115 mg"],
            correctIndex: 1,
            explanation: "176 lb ÷ 2.2 = 80 kg. 80 kg × 1.5 mg/kg = 120 mg. Answering 264 mg comes from multiplying pounds by the mg/kg factor without converting; 80 mg is the weight in kilograms, not the dose."),

        Question(
            id: "F011", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .analysis,
            prompt: "How many milliequivalents of potassium are in 1 gram of potassium chloride? (Atomic weights: K = 39, Cl = 35.5)",
            choices: ["13.4 mEq", "26.8 mEq", "74.5 mEq", "39 mEq"],
            correctIndex: 0,
            explanation: "Molecular weight of KCl = 39 + 35.5 = 74.5. Potassium is monovalent, so the equivalent weight equals the molecular weight: 74.5 mg = 1 mEq. 1,000 mg ÷ 74.5 mg/mEq ≈ 13.4 mEq."),

        Question(
            id: "F012", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .analysis,
            prompt: "A TPN order contains 500 mL of 10% amino acids, 400 mL of 50% dextrose, and 200 mL of 20% lipid emulsion. Approximately how many kilocalories does it provide? (Use 4 kcal/g protein, 3.4 kcal/g dextrose, 2 kcal/mL for 20% lipid.)",
            choices: ["880 kcal", "1,080 kcal", "1,280 kcal", "1,480 kcal"],
            correctIndex: 2,
            explanation: "Amino acids: 500 mL × 10% = 50 g × 4 = 200 kcal. Dextrose: 400 mL × 50% = 200 g × 3.4 = 680 kcal. Lipid: 200 mL × 2 kcal/mL = 400 kcal. Total = 200 + 680 + 400 = 1,280 kcal. Note dextrose is 3.4 kcal/g in solution, not 4."),

        Question(
            id: "F013", domain: .foundational, topic: "Pharmaceutical calculations",
            difficulty: .application,
            prompt: "What is the estimated creatinine clearance for an 80-year-old man weighing 70 kg with a serum creatinine of 1.4 mg/dL, using Cockcroft-Gault?",
            choices: ["34 mL/min", "42 mL/min", "50 mL/min", "58 mL/min"],
            correctIndex: 1,
            explanation: "CrCl = [(140 − age) × weight] / (72 × SCr) = [(140 − 80) × 70] / (72 × 1.4) = 4,200 / 100.8 ≈ 42 mL/min. For women the result is multiplied by 0.85."),

        Question(
            id: "F014", domain: .foundational, topic: "Sterile compounding",
            difficulty: .recall,
            prompt: "Under USP <797>, what is the minimum ISO classification required for the primary engineering control in which sterile compounding is performed?",
            choices: ["ISO Class 5", "ISO Class 7", "ISO Class 8", "ISO Class 9"],
            correctIndex: 0,
            explanation: "Direct compounding areas must be ISO Class 5 or better — a laminar airflow workbench, biological safety cabinet, or isolator. The surrounding buffer room is typically ISO Class 7 and the ante-room ISO Class 8; those describe the room, not the hood."),

        Question(
            id: "F015", domain: .foundational, topic: "Sterile compounding",
            difficulty: .application,
            prompt: "A hazardous drug is being compounded. Which primary engineering control is appropriate?",
            choices: ["Horizontal laminar airflow workbench",
                      "Class II biological safety cabinet vented externally",
                      "Open bench with a face shield",
                      "Compounding aseptic isolator with recirculated unfiltered air"],
            correctIndex: 1,
            explanation: "USP <800> requires a containment primary engineering control for hazardous drugs — commonly a Class II BSC or a containment aseptic containment isolator, externally vented. A horizontal laminar airflow hood blows air toward the operator, which protects the product but exposes the compounder — exactly wrong for a hazardous drug."),

        Question(
            id: "F016", domain: .foundational, topic: "Nonsterile compounding",
            difficulty: .recall,
            prompt: "Levigation in nonsterile compounding refers to:",
            choices: ["Heating an ointment base to melt it",
                      "Triturating a powder with a small amount of liquid to reduce particle size",
                      "Passing a powder through a fine sieve",
                      "Mixing two powders of unequal quantity in progressive proportions"],
            correctIndex: 1,
            explanation: "Levigation wets the powder with a levigating agent (mineral oil, glycerin) and triturates it into a smooth paste, reducing grittiness. Mixing unequal quantities in steps is geometric dilution; melting the base is fusion."),

        Question(
            id: "F017", domain: .foundational, topic: "Pharmaceutics",
            difficulty: .application,
            prompt: "Why should enteric-coated tablets not be crushed?",
            choices: ["Crushing lowers the drug's volume of distribution",
                      "The coating protects the drug from gastric acid or protects the stomach from the drug",
                      "Crushing converts the drug to an inactive isomer",
                      "The coating is required for absorption in the colon only"],
            correctIndex: 1,
            explanation: "Enteric coatings delay release until the higher pH of the small intestine, either to shield an acid-labile drug or to spare the gastric mucosa. Crushing destroys that protection, causing degradation or gastric irritation, and can also produce dose dumping in modified-release products."),

        Question(
            id: "F018", domain: .foundational, topic: "Pharmaceutics",
            difficulty: .recall,
            prompt: "Which term describes the fraction of an administered dose that reaches systemic circulation unchanged?",
            choices: ["Clearance", "Bioavailability", "Volume of distribution", "Extraction ratio"],
            correctIndex: 1,
            explanation: "Bioavailability (F) is that fraction; intravenous administration is defined as F = 1. Drugs with extensive first-pass metabolism have low oral bioavailability, which is why oral and IV doses of the same drug often differ substantially."),

        Question(
            id: "F019", domain: .foundational, topic: "Study design & biostatistics",
            difficulty: .analysis,
            prompt: "A trial reports that a drug reduces event rates from 10% to 5%. What is the number needed to treat?",
            choices: ["5", "10", "20", "50"],
            correctIndex: 2,
            explanation: "Absolute risk reduction = 10% − 5% = 5% = 0.05. NNT = 1 / ARR = 1 / 0.05 = 20. Answering 2 would come from the relative risk reduction (50%), which does not give NNT — this is precisely why absolute figures matter more than relative ones."),

        Question(
            id: "F020", domain: .foundational, topic: "Study design & biostatistics",
            difficulty: .analysis,
            prompt: "A study reports a relative risk of 0.80 with a 95% confidence interval of 0.62 to 1.03. How should this be interpreted?",
            choices: ["A statistically significant 20% risk reduction",
                      "Not statistically significant, because the interval crosses 1.0",
                      "Not statistically significant, because the interval crosses 0",
                      "A statistically significant increase in risk"],
            correctIndex: 1,
            explanation: "For a ratio measure (RR, OR, HR), the null value is 1.0; an interval spanning 1.0 is not significant at that level. For a difference measure (risk difference, mean difference), the null value is 0 instead. The point estimate suggests benefit, but the data are compatible with a small harm."),

        Question(
            id: "F021", domain: .foundational, topic: "Study design & biostatistics",
            difficulty: .recall,
            prompt: "Intention-to-treat analysis means participants are analyzed:",
            choices: ["Only if they completed the study protocol",
                      "According to the group to which they were randomized, regardless of adherence",
                      "According to the treatment they actually received",
                      "Only if they received at least one dose"],
            correctIndex: 1,
            explanation: "ITT preserves the balance created by randomization and gives a conservative, real-world estimate of effect. Analyzing by treatment actually received is per-protocol analysis, which can reintroduce selection bias because adherence itself predicts outcome."),

        Question(
            id: "F022", domain: .foundational, topic: "Drug development & trial phases",
            difficulty: .recall,
            prompt: "Which clinical trial phase first evaluates a new drug in a large patient population to establish efficacy and monitor adverse effects?",
            choices: ["Phase I", "Phase II", "Phase III", "Phase IV"],
            correctIndex: 2,
            explanation: "Phase III enrolls large patient populations to confirm efficacy and detect less common adverse effects before approval. Phase I is small and mainly safety and pharmacokinetics in healthy volunteers, Phase II is a smaller efficacy and dose-ranging step, and Phase IV is post-marketing surveillance."),

        Question(
            id: "F023", domain: .foundational, topic: "Using drug information resources",
            difficulty: .application,
            prompt: "Which is the best example of a tertiary drug information resource?",
            choices: ["A randomized controlled trial in a journal",
                      "A PubMed search result list",
                      "A drug information textbook or compendium",
                      "An unpublished conference abstract"],
            correctIndex: 2,
            explanation: "Tertiary resources — textbooks, compendia, and review databases — condense and interpret existing literature, making them the fastest starting point though the slowest to reflect new findings. A randomized trial is primary literature; an indexing or abstracting service such as PubMed is secondary."),

        Question(
            id: "F024", domain: .foundational, topic: "Pharmacology",
            difficulty: .application,
            prompt: "Which mechanism explains the antiplatelet action of clopidogrel?",
            choices: ["Irreversible cyclooxygenase-1 inhibition",
                      "Irreversible P2Y12 ADP receptor antagonism",
                      "Glycoprotein IIb/IIIa receptor blockade",
                      "Phosphodiesterase-3 inhibition"],
            correctIndex: 1,
            explanation: "Clopidogrel is a prodrug whose active metabolite irreversibly blocks the platelet P2Y12 ADP receptor. Because activation depends on CYP2C19, poor metabolizers get reduced effect. Irreversible COX-1 inhibition is aspirin; PDE-3 inhibition is cilostazol."),

        Question(
            id: "F025", domain: .foundational, topic: "Pharmacokinetics & pharmacodynamics",
            difficulty: .application,
            prompt: "A drug is 95% protein bound. In severe hypoalbuminemia, what happens initially?",
            choices: ["Total drug concentration rises and free drug falls",
                      "Free (unbound) drug fraction rises, potentially increasing effect and toxicity",
                      "Both total and free concentrations fall proportionally with no clinical change",
                      "Protein binding has no bearing on pharmacologic effect"],
            correctIndex: 1,
            explanation: "Only unbound drug is pharmacologically active. Less albumin means a higher free fraction, so a measured total concentration can look 'therapeutic' while free drug is high — the classic problem with phenytoin levels in hypoalbuminemia, where a corrected or free level should be obtained.")
    ]
}
