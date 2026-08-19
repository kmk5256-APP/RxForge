import Foundation

// Domain 5 — Pharmacy Management and Leadership (5% of the exam).
// IDs are stable: never renumber, never reuse.

extension QuestionBank {
    static let managementLeadership: [Question] = [

        Question(
            id: "L001", domain: .managementLeadership, topic: "Quality improvement",
            difficulty: .application,
            prompt: "A root-cause analysis is being conducted after a dispensing error. What is its primary purpose?",
            choices: ["Identify which employee to discipline",
                      "Identify the underlying system failures that allowed the error to occur",
                      "Determine the financial cost of the error",
                      "Satisfy the insurer's documentation requirement"],
            correctIndex: 1,
            explanation: "Root-cause analysis is a systems method: it asks what conditions permitted a competent person to err — look-alike packaging, interruption-heavy workflow, ambiguous order entry — and targets those. Framing it as a search for someone to blame suppresses reporting and leaves the latent conditions in place to cause the next error."),

        Question(
            id: "L002", domain: .managementLeadership, topic: "Inventory, recalls & shortages",
            difficulty: .recall,
            prompt: "A Class I recall indicates:",
            choices: ["A minor labeling issue with no health consequence",
                      "A reasonable probability that use will cause serious adverse health consequences or death",
                      "A product that is merely being discontinued",
                      "A voluntary market withdrawal for business reasons"],
            correctIndex: 1,
            explanation: "Class I is the most serious category, indicating a reasonable probability of serious harm or death. Class II involves temporary or medically reversible consequences with remote probability of serious harm, and Class III is unlikely to cause adverse consequences — typically a labeling or packaging defect."),

        Question(
            id: "L003", domain: .managementLeadership, topic: "Pharmacy operations & informatics",
            difficulty: .application,
            prompt: "Which technology control most directly reduces the risk of dispensing the wrong drug?",
            choices: ["Automated refill reminders",
                      "Barcode verification of the stock bottle against the prescription record",
                      "Electronic signature capture at pickup",
                      "Automated insurance adjudication"],
            correctIndex: 1,
            explanation: "Barcode scanning at the point of product selection verifies the NDC against the order, catching look-alike and shelf-adjacency errors before the drug reaches the vial. Refill reminders, signature capture, and adjudication serve adherence, documentation, and billing respectively — none verifies that the right product was pulled."),

        Question(
            id: "L004", domain: .managementLeadership, topic: "Inventory, recalls & shortages",
            difficulty: .application,
            prompt: "During a drug shortage, which action is most appropriate for a pharmacy manager?",
            choices: ["Purchase from an unlicensed secondary distributor offering stock at a premium",
                      "Assess remaining inventory, identify therapeutic alternatives with prescriber input, and prioritize patients by clinical need",
                      "Fill prescriptions first-come-first-served until stock runs out with no planning",
                      "Dilute existing stock to extend supply"],
            correctIndex: 1,
            explanation: "Shortage management means quantifying what is on hand, working with prescribers on therapeutic alternatives, and allocating by clinical urgency. Buying from unlicensed sources risks counterfeit or diverted product and violates supply-chain security requirements under the Drug Supply Chain Security Act. Diluting stock is adulteration."),

        Question(
            id: "L005", domain: .managementLeadership, topic: "Mentorship & precepting",
            difficulty: .analysis,
            prompt: "A preceptor observes a student give a patient incorrect counseling information. What is the most appropriate action?",
            choices: ["Correct the student in front of the patient to reinforce the lesson",
                      "Interject to correct the information for the patient's safety, then debrief the student privately",
                      "Say nothing and address it at the end of the rotation",
                      "Remove the student from patient care for the remainder of the rotation"],
            correctIndex: 1,
            explanation: "Patient safety comes first, so the incorrect information must be corrected before the patient leaves — but the teaching happens privately afterward, where specific, timely feedback can be given without humiliating the learner in front of the patient. Delaying to the end of the rotation wastes the teachable moment and leaves the patient misinformed.")
    ]
}
