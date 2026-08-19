import Foundation

// Domain 4 — Professional Practice (5% of the exam).
// IDs are stable: never renumber, never reuse.

extension QuestionBank {
    static let professionalPractice: [Question] = [

        Question(
            id: "P001", domain: .professionalPractice, topic: "Adverse event & error reporting",
            difficulty: .recall,
            prompt: "Which program should be used to report a suspected serious adverse event associated with a prescription drug?",
            choices: ["VAERS", "MedWatch", "The National Practitioner Data Bank", "The Orange Book"],
            correctIndex: 1,
            explanation: "MedWatch is FDA's voluntary reporting system for adverse events, product quality problems, and medication errors involving drugs, biologics, and devices. VAERS is the parallel system specifically for vaccines, jointly run by FDA and CDC. Reporting is voluntary for clinicians but mandatory for manufacturers."),

        Question(
            id: "P002", domain: .professionalPractice, topic: "Adverse event & error reporting",
            difficulty: .application,
            prompt: "A patient develops syncope two hours after receiving an influenza vaccine at the pharmacy. Where should this be reported?",
            choices: ["MedWatch", "VAERS", "DEA Form 106", "The state board of pharmacy only"],
            correctIndex: 1,
            explanation: "Adverse events following immunization go to VAERS, the Vaccine Adverse Event Reporting System. Certain events are legally required to be reported. Syncope after vaccination is common enough that patients should be observed for 15 minutes afterward, seated or lying down."),

        Question(
            id: "P003", domain: .professionalPractice, topic: "Ethics & professional conduct",
            difficulty: .analysis,
            prompt: "A patient's spouse calls asking which medications the patient is taking. The patient has given no authorization. What is the appropriate response?",
            choices: ["Provide the list because spouses are automatically authorized",
                      "Decline to disclose and explain that patient authorization is required under HIPAA",
                      "Provide only the drug names but not the doses",
                      "Ask the spouse to verify the patient's date of birth, then disclose"],
            correctIndex: 1,
            explanation: "Protected health information may not be disclosed to a spouse absent patient authorization or an applicable exception such as involvement in care with the patient's agreement or opportunity to object. Marital status alone confers no right of access, and knowing identifying details does not establish authorization."),

        Question(
            id: "P004", domain: .professionalPractice, topic: "Public health & stewardship",
            difficulty: .application,
            prompt: "Which action best reflects antimicrobial stewardship at the community pharmacy level?",
            choices: ["Dispensing broad-spectrum antibiotics preferentially",
                      "Counseling on completing therapy as prescribed and questioning antibiotic orders for likely viral illness",
                      "Recommending antibiotics for all upper respiratory symptoms",
                      "Keeping antibiotics available without a prescription"],
            correctIndex: 1,
            explanation: "Stewardship at the community level means promoting appropriate use — questioning antibiotics prescribed for likely viral illness, supporting narrow-spectrum choices and correct duration, and counseling patients on expectations. Broad-spectrum-by-default and antibiotics for viral illness are precisely the drivers of resistance stewardship exists to counter."),

        Question(
            id: "P005", domain: .professionalPractice, topic: "Social drivers of health",
            difficulty: .analysis,
            prompt: "A patient reports skipping doses of insulin to make the vial last longer. What is the most appropriate initial pharmacist action?",
            choices: ["Advise the patient that skipping doses is dangerous and end the conversation",
                      "Explore cost barriers and discuss assistance programs, lower-cost insulin options, and prescriber notification",
                      "Report the patient to their insurer",
                      "Recommend the patient stop insulin entirely until they can afford it"],
            correctIndex: 1,
            explanation: "Cost-related underuse is a social driver of health with direct clinical consequences, and simply restating the danger does not remove the barrier. The useful response is practical: manufacturer patient assistance programs, copay cards, lower-cost human insulin options where clinically appropriate, and informing the prescriber so the regimen can be adjusted to what the patient can actually sustain.")
    ]
}
