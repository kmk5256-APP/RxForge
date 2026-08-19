import Foundation
import SwiftUI

/// The five content domains of the NAPLEX Content Outline that took effect for all
/// exams beginning **May 1, 2025**, with the published approximate exam weights.
///
/// This is the single source of truth for domain weights in the app — nothing else may
/// define them (see CLAUDE.md).
///
/// Domain titles and weights are taken from NABP's published content outline. The
/// subtopic lists below are RxForge's own paraphrase of the subdomain structure, not a
/// reproduction of NABP's outline. NAPLEX® is a registered trademark of the National
/// Association of Boards of Pharmacy; RxForge is not affiliated with or endorsed by NABP.
enum Domain: String, CaseIterable, Identifiable, Codable, Hashable {
    case foundational = "Foundational Knowledge for Pharmacy Practice"
    case medicationUse = "Medication Use Process"
    case assessmentPlanning = "Person-Centered Assessment and Treatment Planning"
    case professionalPractice = "Professional Practice"
    case managementLeadership = "Pharmacy Management and Leadership"

    var id: String { rawValue }

    /// Domain number as it appears on the content outline (1–5).
    var number: Int {
        switch self {
        case .foundational: return 1
        case .medicationUse: return 2
        case .assessmentPlanning: return 3
        case .professionalPractice: return 4
        case .managementLeadership: return 5
        }
    }

    /// Published approximate share of the 200 scored questions.
    /// These sum to 1.0 — `Domain.weightsSumToOne` asserts it.
    var examWeight: Double {
        switch self {
        case .foundational: return 0.25
        case .medicationUse: return 0.25
        case .assessmentPlanning: return 0.40
        case .professionalPractice: return 0.05
        case .managementLeadership: return 0.05
        }
    }

    /// Approximate number of scored questions on a 200-question exam.
    var approximateQuestionCount: Int { Int((examWeight * 200).rounded()) }

    /// Short label for tight spaces (tab bars, chips, chart axes).
    var shortName: String {
        switch self {
        case .foundational: return "Foundational"
        case .medicationUse: return "Medication Use"
        case .assessmentPlanning: return "Assessment & Planning"
        case .professionalPractice: return "Professional Practice"
        case .managementLeadership: return "Management"
        }
    }

    /// Parenthetical the outline attaches to domain 2, shown on the domain detail screen.
    var subtitle: String? {
        switch self {
        case .medicationUse:
            return "Prescribing, transcribing and documenting, dispensing, administering, and monitoring"
        default:
            return nil
        }
    }

    var symbol: String {
        switch self {
        case .foundational: return "atom"
        case .medicationUse: return "pills.fill"
        case .assessmentPlanning: return "stethoscope"
        case .professionalPractice: return "checkmark.shield.fill"
        case .managementLeadership: return "chart.bar.doc.horizontal.fill"
        }
    }

    var accent: Color {
        switch self {
        case .foundational: return Color(red: 0.35, green: 0.45, blue: 0.72)
        case .medicationUse: return Color(red: 0.85, green: 0.45, blue: 0.20)
        case .assessmentPlanning: return Color(red: 0.20, green: 0.55, blue: 0.45)
        case .professionalPractice: return Color(red: 0.55, green: 0.38, blue: 0.68)
        case .managementLeadership: return Color(red: 0.72, green: 0.35, blue: 0.42)
        }
    }

    /// What this domain covers, in RxForge's own words.
    var summary: String {
        switch self {
        case .foundational:
            return "The science under the practice — pharmacology, kinetics and dynamics, pharmaceutics, compounding, calculations, how drugs get developed, and how to read the literature."
        case .medicationUse:
            return "Everything from reading the order to handing over the drug: names and classes, dosing, dosage forms, prescription rules, therapeutic substitution, immunizations, and safe handling and storage."
        case .assessmentPlanning:
            return "The largest domain, and the one that decides most exams. Histories and screenings, judging whether therapy fits the patient, interactions, errors, adverse reactions, monitoring plans, counselling, OTC products, and devices."
        case .professionalPractice:
            return "Reporting adverse events and errors, public health and stewardship programs, social drivers of health, and the ethics of practice."
        case .managementLeadership:
            return "Running the pharmacy: operations and informatics, inventory and shortages, quality improvement, and precepting."
        }
    }

    /// RxForge's paraphrase of the subdomain structure, used for the Topics screen and
    /// for tagging questions. Not a reproduction of NABP's outline.
    var topics: [String] {
        switch self {
        case .foundational:
            return ["Pharmacology",
                    "Pharmacokinetics & pharmacodynamics",
                    "Pharmaceutics",
                    "Nonsterile compounding",
                    "Sterile compounding",
                    "Pharmaceutical calculations",
                    "Drug development & trial phases",
                    "Study design & biostatistics",
                    "Using drug information resources"]
        case .medicationUse:
            return ["Drug names & therapeutic classes",
                    "Indications & dosing regimens",
                    "Dosage forms",
                    "Prescription regulations & boxed warnings",
                    "Therapeutic substitution & biosimilars",
                    "Immunization practice",
                    "Storage, stability & disposal"]
        case .assessmentPlanning:
            return ["Medication & allergy history",
                    "Screenings & health assessment",
                    "Disease states & pathophysiology",
                    "Appropriateness of therapy",
                    "Drug interactions",
                    "Errors & omissions",
                    "Adverse drug reactions",
                    "Toxicology & overdose",
                    "Adherence",
                    "Therapeutic monitoring",
                    "Patient education",
                    "OTC & dietary supplements",
                    "Devices & self-monitoring"]
        case .professionalPractice:
            return ["Adverse event & error reporting",
                    "Public health & stewardship",
                    "Social drivers of health",
                    "Ethics & professional conduct"]
        case .managementLeadership:
            return ["Pharmacy operations & informatics",
                    "Inventory, recalls & shortages",
                    "Quality improvement",
                    "Mentorship & precepting"]
        }
    }

    /// Sanity check used by a debug assertion at launch.
    static var weightsSumToOne: Bool {
        abs(allCases.reduce(0) { $0 + $1.examWeight } - 1.0) < 0.0001
    }
}
