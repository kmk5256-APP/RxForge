import Foundation

// Domain 3 — Person-Centered Assessment and Treatment Planning (40% of the exam,
// the largest domain and the one that decides most exams).
// IDs are stable: never renumber, never reuse.

extension QuestionBank {
    static let assessmentPlanning: [Question] = [

        // MARK: Therapeutic monitoring

        Question(
            id: "A001", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .application,
            prompt: "Which laboratory value is most important to monitor in a patient starting lisinopril?",
            choices: ["Serum potassium and creatinine", "Platelet count", "INR", "Serum amylase"],
            correctIndex: 0,
            explanation: "ACE inhibitors reduce aldosterone, causing potassium retention, and can lower glomerular filtration pressure, raising creatinine. Both should be checked at baseline and roughly 1–2 weeks after initiation or dose increase. A creatinine rise up to about 30% is generally tolerated; more than that prompts reassessment."),

        Question(
            id: "A002", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .application,
            prompt: "A patient on amiodarone requires periodic monitoring of which organ systems?",
            choices: ["Renal and hematologic only",
                      "Thyroid, hepatic, pulmonary, and ophthalmologic",
                      "Pancreatic and adrenal",
                      "No routine monitoring is required"],
            correctIndex: 1,
            explanation: "Amiodarone is iodine-rich and highly lipophilic with a half-life measured in weeks. It causes both hypo- and hyperthyroidism, hepatotoxicity, pulmonary fibrosis, and corneal deposits, so thyroid and liver function, chest imaging or pulmonary function, and eye exams are monitored. ECG monitoring for QT prolongation is also required."),

        Question(
            id: "A003", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .analysis,
            prompt: "A patient receiving vancomycin has a trough drawn 30 minutes after the dose finishes. What is the problem?",
            choices: ["The trough should be drawn immediately before the next dose",
                      "The trough should be drawn 6 hours after the dose",
                      "Nothing; timing does not matter",
                      "Troughs are only valid after 10 days of therapy"],
            correctIndex: 0,
            explanation: "A trough is by definition the lowest concentration, drawn within 30 minutes before the next dose and at steady state, typically before the fourth dose. A level drawn just after infusion captures distribution, not trough, and will read falsely high — risking an inappropriate dose reduction. Current guidance increasingly favors AUC-guided dosing over trough-only monitoring."),

        Question(
            id: "A004", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .application,
            prompt: "Which monitoring parameter is most specific for statin-associated muscle injury?",
            choices: ["Serum creatinine", "Creatine kinase", "Alkaline phosphatase", "Serum troponin"],
            correctIndex: 1,
            explanation: "Creatine kinase rises with skeletal muscle injury and is the marker checked when a patient on a statin reports myalgia, weakness, or dark urine. Routine CK monitoring in asymptomatic patients is not recommended — it is checked when symptoms appear. Troponin is cardiac-specific and would not be the first test for muscle complaints."),

        Question(
            id: "A005", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .application,
            prompt: "What is the target INR range for most patients on warfarin for atrial fibrillation?",
            choices: ["1.0 to 1.5", "2.0 to 3.0", "2.5 to 3.5", "3.0 to 4.0"],
            correctIndex: 1,
            explanation: "An INR of 2.0–3.0 is the target for atrial fibrillation, venous thromboembolism treatment, and most other indications. The higher 2.5–3.5 range applies to certain mechanical mitral valves. Below 2.0 provides inadequate protection; above the range increases bleeding without added benefit."),

        Question(
            id: "A006", domain: .assessmentPlanning, topic: "Therapeutic monitoring",
            difficulty: .analysis,
            prompt: "A patient with type 2 diabetes has an A1C of 8.4%. Approximately what average blood glucose does this represent?",
            choices: ["154 mg/dL", "183 mg/dL", "194 mg/dL", "240 mg/dL"],
            correctIndex: 2,
            explanation: "Estimated average glucose = (28.7 × A1C) − 46.7 = (28.7 × 8.4) − 46.7 ≈ 194 mg/dL. A useful anchor is that an A1C of 7% corresponds to about 154 mg/dL, with each additional percentage point adding roughly 28–29 mg/dL."),

        // MARK: Drug interactions

        Question(
            id: "A007", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .analysis,
            prompt: "A patient on sertraline is prescribed linezolid. What is the primary concern?",
            choices: ["Serotonin syndrome", "QT shortening", "Hepatic failure", "Loss of antidepressant effect"],
            correctIndex: 0,
            explanation: "Linezolid is a weak, reversible monoamine oxidase inhibitor. Combined with an SSRI it can precipitate serotonin syndrome — altered mental status, autonomic instability, hyperreflexia, and clonus. If linezolid is essential, the serotonergic agent is usually held with appropriate washout and the patient monitored closely."),

        Question(
            id: "A008", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .application,
            prompt: "Which combination poses the greatest risk of hyperkalemia?",
            choices: ["Lisinopril and spironolactone",
                      "Atorvastatin and aspirin",
                      "Metformin and glipizide",
                      "Amlodipine and hydrochlorothiazide"],
            correctIndex: 0,
            explanation: "An ACE inhibitor reduces aldosterone while spironolactone blocks the aldosterone receptor; both retain potassium, and together in a patient with reduced renal function they can drive dangerous hyperkalemia. Potassium and renal function require close monitoring. Hydrochlorothiazide, by contrast, causes potassium loss."),

        Question(
            id: "A009", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .application,
            prompt: "Grapefruit juice increases concentrations of certain statins by which mechanism?",
            choices: ["Inducing CYP3A4 in the liver",
                      "Inhibiting intestinal CYP3A4",
                      "Increasing renal reabsorption",
                      "Displacing the drug from plasma proteins"],
            correctIndex: 1,
            explanation: "Grapefruit irreversibly inhibits intestinal CYP3A4, reducing first-pass metabolism and raising systemic exposure to simvastatin, lovastatin, and atorvastatin — increasing myopathy risk. Pravastatin, rosuvastatin, and pitavastatin are minimally affected because they are not appreciably CYP3A4 substrates."),

        Question(
            id: "A010", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .analysis,
            prompt: "A patient on warfarin begins trimethoprim/sulfamethoxazole. What is the most likely consequence?",
            choices: ["INR falls, requiring a dose increase",
                      "INR rises, increasing bleeding risk",
                      "No interaction occurs",
                      "Warfarin is rendered inactive"],
            correctIndex: 1,
            explanation: "Sulfamethoxazole inhibits CYP2C9, the enzyme clearing the more potent S-warfarin enantiomer, and also displaces warfarin from albumin and disrupts gut flora producing vitamin K. The result is a sharp INR rise. Bactrim is one of the most clinically important warfarin interactions and warrants an INR check within a few days."),

        Question(
            id: "A011", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .application,
            prompt: "Which interaction warrants counseling a patient taking sildenafil?",
            choices: ["Avoid concurrent nitrates due to risk of severe hypotension",
                      "Avoid dairy products",
                      "Avoid acetaminophen",
                      "Avoid sun exposure"],
            correctIndex: 0,
            explanation: "PDE-5 inhibitors and nitrates both increase cyclic GMP-mediated vasodilation; together they can cause profound, refractory hypotension. The combination is contraindicated, including with as-needed sublingual nitroglycerin, and patients must know the required separation interval — commonly 24 hours for sildenafil and 48 hours for tadalafil."),

        Question(
            id: "A012", domain: .assessmentPlanning, topic: "Drug interactions",
            difficulty: .application,
            prompt: "St. John's wort reduces the effectiveness of many drugs because it:",
            choices: ["Inhibits CYP3A4", "Induces CYP3A4 and P-glycoprotein",
                      "Chelates drugs in the gut", "Increases gastric pH"],
            correctIndex: 1,
            explanation: "St. John's wort is a potent inducer of CYP3A4 and P-glycoprotein, lowering concentrations of oral contraceptives, cyclosporine, tacrolimus, warfarin, and many antiretrovirals. Breakthrough pregnancy and transplant rejection are documented consequences, which is why the herbal history is not optional."),

        // MARK: Appropriateness of therapy

        Question(
            id: "A013", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .analysis,
            prompt: "A 68-year-old with heart failure with reduced ejection fraction is on lisinopril and furosemide. Which addition provides the greatest mortality benefit?",
            choices: ["Digoxin", "A beta-blocker such as carvedilol or metoprolol succinate",
                      "Amlodipine", "Diltiazem"],
            correctIndex: 1,
            explanation: "Evidence-based beta-blockers — carvedilol, metoprolol succinate, bisoprolol — reduce mortality in HFrEF and are foundational alongside renin-angiotensin inhibition, mineralocorticoid antagonists, and SGLT2 inhibitors. Digoxin reduces hospitalizations but not mortality. Non-dihydropyridine calcium channel blockers such as diltiazem are negative inotropes and should generally be avoided in HFrEF."),

        Question(
            id: "A014", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .analysis,
            prompt: "Which medication should be avoided in a patient with a history of angioedema on an ACE inhibitor?",
            choices: ["Amlodipine", "Hydrochlorothiazide", "Sacubitril/valsartan", "Metoprolol"],
            correctIndex: 2,
            explanation: "Sacubitril inhibits neprilysin, which degrades bradykinin — the same mediator implicated in ACE inhibitor angioedema — so the combination product is contraindicated with a history of ACE inhibitor-associated angioedema, and requires a 36-hour washout when switching from an ACE inhibitor. Amlodipine, thiazides, and beta-blockers do not act on bradykinin."),

        Question(
            id: "A015", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .application,
            prompt: "Which antihypertensive class is preferred first-line in a patient with diabetes and albuminuria?",
            choices: ["Beta-blocker", "ACE inhibitor or ARB",
                      "Non-dihydropyridine calcium channel blocker", "Alpha-blocker"],
            correctIndex: 1,
            explanation: "ACE inhibitors and ARBs reduce intraglomerular pressure and slow progression of albuminuric kidney disease, benefits independent of blood pressure lowering. They are not combined with each other because dual blockade increases hyperkalemia and acute kidney injury without added benefit."),

        Question(
            id: "A016", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .analysis,
            prompt: "A patient with an eGFR of 25 mL/min/1.73 m² is prescribed metformin. What is the appropriate response?",
            choices: ["Dispense as written",
                      "Contact the prescriber; metformin is contraindicated below an eGFR of 30",
                      "Halve the dose and dispense",
                      "Dispense with instructions to take every other day"],
            correctIndex: 1,
            explanation: "Metformin is contraindicated at an eGFR below 30 mL/min/1.73 m² because reduced clearance raises the risk of lactic acidosis. Between 30 and 45 it is not recommended to initiate, and continuing requires dose reduction and closer monitoring. The pharmacist should contact the prescriber rather than improvise a dose."),

        Question(
            id: "A017", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .application,
            prompt: "Which medication is contraindicated in pregnancy?",
            choices: ["Levothyroxine", "Insulin", "Isotretinoin", "Acetaminophen"],
            correctIndex: 2,
            explanation: "Isotretinoin is a potent teratogen causing craniofacial, cardiac, and CNS malformations, and is governed by the iPLEDGE REMS requiring two forms of contraception and regular pregnancy testing. ACE inhibitors, ARBs, warfarin, methotrexate, and valproate are other high-yield teratogens. Levothyroxine and insulin are in fact essential to continue in pregnancy."),

        Question(
            id: "A018", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .analysis,
            prompt: "An 82-year-old presents with a new prescription for diphenhydramine for insomnia. Based on Beers Criteria, what is the concern?",
            choices: ["Risk of QT prolongation",
                      "Strong anticholinergic effects causing confusion, falls, urinary retention, and constipation",
                      "Hepatotoxicity",
                      "It is ineffective for insomnia at any age"],
            correctIndex: 1,
            explanation: "First-generation antihistamines are on the Beers list as potentially inappropriate in older adults because of strong anticholinergic burden — cognitive impairment, delirium, falls, dry mouth, urinary retention, and constipation — plus rapid tolerance to the sedating effect. Non-pharmacologic sleep measures are preferred."),

        Question(
            id: "A019", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .application,
            prompt: "Which agent is first-line for uncomplicated cystitis in a non-pregnant adult, assuming no allergy or resistance concerns?",
            choices: ["Nitrofurantoin", "Levofloxacin", "Amoxicillin", "Azithromycin"],
            correctIndex: 0,
            explanation: "Nitrofurantoin, trimethoprim/sulfamethoxazole, and fosfomycin are first-line for uncomplicated cystitis. Fluoroquinolones are reserved because of boxed warnings covering tendinopathy, peripheral neuropathy, and CNS effects, and because of stewardship concerns. Nitrofurantoin should be avoided when CrCl is low and in suspected pyelonephritis, since it does not achieve adequate tissue concentrations."),

        Question(
            id: "A020", domain: .assessmentPlanning, topic: "Appropriateness of therapy",
            difficulty: .analysis,
            prompt: "A patient with asthma and hypertension is prescribed propranolol. What is the concern?",
            choices: ["Propranolol worsens hypertension",
                      "Non-selective beta-blockade can cause bronchoconstriction",
                      "Propranolol interacts with inhaled corticosteroids",
                      "There is no concern"],
            correctIndex: 1,
            explanation: "Propranolol blocks beta-2 receptors in bronchial smooth muscle and can trigger bronchospasm while blunting the response to rescue albuterol. A cardioselective agent such as metoprolol or atenolol is preferred if a beta-blocker is needed, though selectivity is dose-dependent and diminishes at higher doses."),

        // MARK: Adverse drug reactions

        Question(
            id: "A021", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .application,
            prompt: "A patient starting lisinopril develops a persistent dry cough. What is the mechanism and appropriate action?",
            choices: ["Histamine release; add an antihistamine",
                      "Bradykinin accumulation; switch to an ARB",
                      "Direct airway irritation; take with food",
                      "Reflex tachycardia; reduce the dose"],
            correctIndex: 1,
            explanation: "ACE inhibitors block degradation of bradykinin and substance P in the airway, producing a dry cough in roughly 10–20% of patients. It is not dose-related and does not resolve with continued use. ARBs do not affect bradykinin and are the standard substitution."),

        Question(
            id: "A022", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .analysis,
            prompt: "A patient on lamotrigine develops a rapidly spreading rash with mucosal involvement. What is the appropriate action?",
            choices: ["Continue and add diphenhydramine",
                      "Stop lamotrigine immediately and seek urgent evaluation for Stevens-Johnson syndrome",
                      "Halve the dose and reassess in one week",
                      "Apply topical corticosteroid and continue"],
            correctIndex: 1,
            explanation: "Rash with mucosal involvement on lamotrigine suggests Stevens-Johnson syndrome or toxic epidermal necrolysis, which can be fatal. The drug is stopped immediately and the patient evaluated urgently. Risk is highest in the first 8 weeks and with too-rapid titration or concurrent valproate, which raises lamotrigine concentrations — hence the mandatory slow titration schedule."),

        Question(
            id: "A023", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .application,
            prompt: "Which adverse effect is characteristic of long-term high-dose inhaled corticosteroid use?",
            choices: ["Oral candidiasis and dysphonia", "Hyperkalemia", "Nephrotoxicity", "Ototoxicity"],
            correctIndex: 0,
            explanation: "Local deposition in the oropharynx causes thrush and hoarseness. Rinsing the mouth and spitting after each use, and using a spacer with metered-dose inhalers, substantially reduce both. Systemic effects such as adrenal suppression and reduced bone density become relevant at high doses over time."),

        Question(
            id: "A024", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .analysis,
            prompt: "A patient on haloperidol develops fever, muscle rigidity, altered mental status, and elevated creatine kinase. What is the most likely diagnosis?",
            choices: ["Serotonin syndrome", "Neuroleptic malignant syndrome",
                      "Malignant hyperthermia", "Tardive dyskinesia"],
            correctIndex: 1,
            explanation: "That tetrad — hyperthermia, lead-pipe rigidity, autonomic instability, and altered mental status with elevated CK — is neuroleptic malignant syndrome, caused by dopamine blockade. Treatment is stopping the antipsychotic plus supportive care, with dantrolene or bromocriptine in severe cases. Serotonin syndrome differs by featuring hyperreflexia and clonus rather than rigidity, and by onset within hours rather than days."),

        Question(
            id: "A025", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .application,
            prompt: "Which electrolyte abnormality is most associated with loop diuretics?",
            choices: ["Hyperkalemia", "Hypokalemia and hypomagnesemia",
                      "Hypercalcemia", "Hypernatremia"],
            correctIndex: 1,
            explanation: "Loop diuretics inhibit the Na-K-2Cl transporter, increasing distal sodium delivery and driving potassium and magnesium loss; they also increase calcium excretion. Hypokalemia raises digoxin toxicity risk and arrhythmia risk, and hypomagnesemia makes hypokalemia refractory until the magnesium is replaced."),

        Question(
            id: "A026", domain: .assessmentPlanning, topic: "Adverse drug reactions",
            difficulty: .application,
            prompt: "Which antibiotic class is most associated with tendon rupture?",
            choices: ["Macrolides", "Fluoroquinolones", "Cephalosporins", "Penicillins"],
            correctIndex: 1,
            explanation: "Fluoroquinolones carry a boxed warning for tendinitis and tendon rupture, most often the Achilles, with risk elevated in patients over 60, those on corticosteroids, and transplant recipients. The same boxed warning covers peripheral neuropathy, CNS effects, and exacerbation of myasthenia gravis."),

        // MARK: Toxicology & overdose

        Question(
            id: "A027", domain: .assessmentPlanning, topic: "Toxicology & overdose",
            difficulty: .recall,
            prompt: "What is the antidote for acetaminophen overdose?",
            choices: ["Naloxone", "N-acetylcysteine", "Flumazenil", "Deferoxamine"],
            correctIndex: 1,
            explanation: "N-acetylcysteine replenishes glutathione, allowing detoxification of the reactive metabolite NAPQI. It is most effective within 8–10 hours of ingestion but is still given later. The Rumack-Matthew nomogram guides treatment for single acute ingestions with a known time."),

        Question(
            id: "A028", domain: .assessmentPlanning, topic: "Toxicology & overdose",
            difficulty: .application,
            prompt: "Which antidote reverses opioid-induced respiratory depression?",
            choices: ["Flumazenil", "Naloxone", "Physostigmine", "Protamine sulfate"],
            correctIndex: 1,
            explanation: "Naloxone is a competitive opioid receptor antagonist that reverses respiratory depression within minutes. Its duration is often shorter than that of the opioid — especially methadone or extended-release products — so repeat dosing and continued observation are required. Flumazenil reverses benzodiazepines; protamine reverses heparin."),

        Question(
            id: "A029", domain: .assessmentPlanning, topic: "Toxicology & overdose",
            difficulty: .analysis,
            prompt: "A patient on warfarin has an INR of 8.0 with no bleeding. What is the most appropriate management?",
            choices: ["Continue warfarin unchanged",
                      "Hold warfarin and give oral vitamin K, with close INR monitoring",
                      "Give IV protamine sulfate",
                      "Administer fresh frozen plasma immediately"],
            correctIndex: 1,
            explanation: "For a markedly elevated INR without bleeding, warfarin is held and low-dose oral vitamin K given, with INR rechecked in 24 hours. Four-factor prothrombin complex concentrate plus IV vitamin K is reserved for serious or life-threatening bleeding. Protamine reverses heparin, not warfarin."),

        Question(
            id: "A030", domain: .assessmentPlanning, topic: "Toxicology & overdose",
            difficulty: .application,
            prompt: "Which finding suggests digoxin toxicity?",
            choices: ["Nausea, visual disturbances with yellow-green halos, and bradyarrhythmias",
                      "Dry cough and angioedema",
                      "Photosensitivity and tendon pain",
                      "Metallic taste and lactic acidosis"],
            correctIndex: 0,
            explanation: "Classic digoxin toxicity combines gastrointestinal upset, visual changes described as yellow-green halos, confusion, and arrhythmias including bradycardia and AV block. Hypokalemia, hypomagnesemia, and renal impairment all predispose. Digoxin immune Fab is the antidote for severe toxicity."),

        // MARK: Disease states & pathophysiology

        Question(
            id: "A031", domain: .assessmentPlanning, topic: "Disease states & pathophysiology",
            difficulty: .application,
            prompt: "Which finding best distinguishes type 1 from type 2 diabetes at presentation?",
            choices: ["Presence of obesity",
                      "Autoantibodies with absolute insulin deficiency and a tendency to ketoacidosis",
                      "Elevated A1C",
                      "Family history of diabetes"],
            correctIndex: 1,
            explanation: "Type 1 diabetes is autoimmune beta-cell destruction producing absolute insulin deficiency, so patients present with weight loss, marked hyperglycemia, and a propensity to diabetic ketoacidosis, often with detectable autoantibodies and low C-peptide. Type 2 involves insulin resistance with relative deficiency. Obesity and family history occur in both and do not distinguish them."),

        Question(
            id: "A032", domain: .assessmentPlanning, topic: "Disease states & pathophysiology",
            difficulty: .application,
            prompt: "A patient presents with sudden unilateral weakness and slurred speech starting 90 minutes ago. Which is the priority consideration?",
            choices: ["Begin aspirin 81 mg daily at home",
                      "Urgent evaluation for acute ischemic stroke and possible thrombolysis",
                      "Schedule a routine clinic appointment",
                      "Start a statin and reassess in one week"],
            correctIndex: 1,
            explanation: "These are stroke symptoms within the thrombolytic window; alteplase or tenecteplase is generally considered up to 4.5 hours from last known well, after hemorrhage is excluded by imaging. Time is brain — any delay for outpatient measures costs salvageable tissue. Antiplatelet therapy and statins matter for secondary prevention, not the acute event."),

        Question(
            id: "A033", domain: .assessmentPlanning, topic: "Disease states & pathophysiology",
            difficulty: .analysis,
            prompt: "Which class is preferred for a patient with type 2 diabetes and established atherosclerotic cardiovascular disease?",
            choices: ["Sulfonylurea", "GLP-1 receptor agonist or SGLT2 inhibitor with proven cardiovascular benefit",
                      "Thiazolidinedione", "Alpha-glucosidase inhibitor"],
            correctIndex: 1,
            explanation: "Guidelines recommend agents with demonstrated cardiovascular outcome benefit — GLP-1 receptor agonists or SGLT2 inhibitors — independent of A1C, in patients with established ASCVD. SGLT2 inhibitors are additionally favored with heart failure or chronic kidney disease. Sulfonylureas lower glucose but confer no cardiovascular benefit and carry hypoglycemia and weight gain."),

        // MARK: Patient education

        Question(
            id: "A034", domain: .assessmentPlanning, topic: "Patient education",
            difficulty: .application,
            prompt: "Which counseling point is most important for a patient starting metformin?",
            choices: ["Expect hypoglycemia and carry glucose tablets",
                      "Take with meals; GI upset is common initially and usually improves",
                      "Avoid all carbohydrates",
                      "Stop if urine becomes darker"],
            correctIndex: 1,
            explanation: "Diarrhea, nausea, and abdominal discomfort are the common early complaints; taking metformin with food, starting low, and titrating slowly mitigate them, and the extended-release form is better tolerated. Metformin alone rarely causes hypoglycemia because it does not stimulate insulin secretion. Patients should also know to hold it around iodinated contrast procedures."),

        Question(
            id: "A035", domain: .assessmentPlanning, topic: "Patient education",
            difficulty: .application,
            prompt: "A patient is prescribed a metered-dose inhaler with a spacer. Which instruction is correct?",
            choices: ["Inhale as rapidly and forcefully as possible",
                      "Breathe in slowly and deeply, then hold the breath for about 10 seconds",
                      "Exhale into the spacer after actuating",
                      "Take four puffs in immediate succession without pause"],
            correctIndex: 1,
            explanation: "A slow, deep inhalation followed by a 10-second breath hold maximizes lower-airway deposition from a metered-dose inhaler. Rapid forceful inhalation drives drug into the oropharynx. Note the contrast with dry powder inhalers, which require a fast, forceful breath to disaggregate the powder — a distinction worth knowing cold."),

        Question(
            id: "A036", domain: .assessmentPlanning, topic: "Patient education",
            difficulty: .application,
            prompt: "A patient taking warfarin asks about diet. What is the best advice?",
            choices: ["Avoid all green vegetables permanently",
                      "Keep vitamin K intake consistent rather than eliminating it",
                      "Double the warfarin dose on days with salad",
                      "Vitamin K has no effect on warfarin"],
            correctIndex: 1,
            explanation: "Warfarin is titrated against the patient's habitual vitamin K intake, so consistency is what matters — large swings destabilize the INR in either direction. Eliminating leafy greens is unnecessary and nutritionally counterproductive. Patients should also be counselled that alcohol binges and many antibiotics disturb control."),

        // MARK: OTC & dietary supplements

        Question(
            id: "A037", domain: .assessmentPlanning, topic: "OTC & dietary supplements",
            difficulty: .analysis,
            prompt: "A patient with hypertension asks about an OTC decongestant for nasal congestion. What is the best recommendation?",
            choices: ["Oral pseudoephedrine at the maximum dose",
                      "Saline nasal spray or intranasal corticosteroid, avoiding oral sympathomimetic decongestants",
                      "Oral phenylephrine indefinitely",
                      "No treatment is safe"],
            correctIndex: 1,
            explanation: "Oral sympathomimetic decongestants cause vasoconstriction that can raise blood pressure and blunt antihypertensive therapy. Saline irrigation and intranasal corticosteroids are effective without the systemic pressor effect. Topical decongestants like oxymetazoline are an option for a maximum of 3 days because of rebound congestion."),

        Question(
            id: "A038", domain: .assessmentPlanning, topic: "OTC & dietary supplements",
            difficulty: .application,
            prompt: "Which OTC analgesic is generally preferred in a patient with chronic kidney disease?",
            choices: ["Ibuprofen", "Naproxen", "Acetaminophen within recommended dose limits", "Aspirin at analgesic doses"],
            correctIndex: 2,
            explanation: "NSAIDs inhibit prostaglandin-mediated afferent arteriolar dilation, reducing renal perfusion and risking acute kidney injury, fluid retention, and hyperkalemia in chronic kidney disease. Acetaminophen is preferred, keeping total daily intake at or below 3–4 g and accounting for combination products that hide additional acetaminophen."),

        // MARK: Errors, adherence, history, devices

        Question(
            id: "A039", domain: .assessmentPlanning, topic: "Errors & omissions",
            difficulty: .analysis,
            prompt: "During medication reconciliation, a patient's home list includes both lisinopril and losartan. What is the most appropriate action?",
            choices: ["Dispense both as listed",
                      "Contact the prescriber; combined ACE inhibitor and ARB therapy is generally avoided",
                      "Substitute a beta-blocker for both",
                      "Advise the patient to alternate days"],
            correctIndex: 1,
            explanation: "Dual renin-angiotensin blockade increases hyperkalemia, hypotension, and acute kidney injury without added cardiovascular benefit, and is generally avoided. Duplicate therapy across classes is a frequent reconciliation finding — often one agent was meant to replace the other and the discontinuation never reached the list. The resolution is a prescriber call, not an improvised regimen."),

        Question(
            id: "A040", domain: .assessmentPlanning, topic: "Adherence",
            difficulty: .application,
            prompt: "A patient's refill history shows they obtained a 30-day supply of atorvastatin four times in the past 12 months. What does this most likely indicate?",
            choices: ["Excellent adherence",
                      "Poor adherence warranting a non-judgmental conversation about barriers",
                      "The prescription has expired",
                      "The dose is too high"],
            correctIndex: 1,
            explanation: "Four fills covers roughly 120 of 365 days — a proportion of days covered near 33%, far below the 80% threshold generally used to define adherence. The productive response is to explore the reason — cost, adverse effects, health beliefs, forgetting — rather than repeat instructions the patient has already heard.")
    ]
}
