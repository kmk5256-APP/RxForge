import SwiftUI

struct SettingsView: View {
    @Environment(ProgressManager.self) private var progressManager
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var showingResetConfirm = false
    @State private var wantsExamDate = false
    @State private var examDate = Date()
    @State private var goal = 20

    var body: some View {
        Form {
            Section("Study plan") {
                Toggle("Exam date", isOn: $wantsExamDate.animation())
                    .tint(.brandPrimary)

                if wantsExamDate {
                    DatePicker("Date", selection: $examDate,
                               in: Date()..., displayedComponents: .date)
                        .tint(.brandPrimary)
                }

                Stepper("Daily goal: \(goal) questions", value: $goal, in: 5...100, step: 5)
            }

            Section {
                LabeledContent("Questions in bank", value: "\(QuestionBank.all.count)")
                LabeledContent("Answered", value: "\(progressManager.readiness.totalAttempts)")
                LabeledContent("Study time", value: Format.duration(progressManager.totalStudyTime))
            } header: {
                Text("Your data")
            } footer: {
                Text("Everything RxForge stores stays on this device. There is no account, no server, and no analytics.")
            }

            Section {
                NavigationLink("About RxForge") { AboutView() }
                Button("Replay the intro") { hasCompletedOnboarding = false }
                    .tint(.brandPrimary)
            }

            Section {
                Button("Reset all progress", role: .destructive) {
                    showingResetConfirm = true
                }
            } footer: {
                Text("Deletes every answer, session, and streak. This cannot be undone.")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            wantsExamDate = progressManager.examDate != nil
            examDate = progressManager.examDate ?? Calendar.current.date(byAdding: .month, value: 2, to: Date()) ?? Date()
            goal = progressManager.dailyGoal
        }
        .onChange(of: wantsExamDate) { _, on in
            progressManager.examDate = on ? examDate : nil
        }
        .onChange(of: examDate) { _, newValue in
            if wantsExamDate { progressManager.examDate = newValue }
        }
        .onChange(of: goal) { _, newValue in
            progressManager.dailyGoal = newValue
        }
        .confirmationDialog("Reset all progress?",
                            isPresented: $showingResetConfirm,
                            titleVisibility: .visible) {
            Button("Delete everything", role: .destructive) {
                progressManager.resetAllProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Every answer, session, and streak will be deleted. This cannot be undone.")
        }
    }
}

struct AboutView: View {
    private var version: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("RxForge")
                        .font(.title.weight(.bold))
                    Text("Version \(version)")
                        .font(.caption)
                        .foregroundStyle(Color.brandSlate)
                }

                Text("A NAPLEX readiness diagnostic. It scores where you stand across the five content domains, weighted the way the exam weights them, and tells you which domain is worth your next hour.")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                section("About the Readiness Score",
                        "The score combines blueprint-weighted accuracy, how much you've answered, and how consistently you study. It is a study-progress measure only. It is not a predicted NAPLEX score, a percentile, or a probability of passing, and it should not be used to decide whether to sit the exam.")

                section("Content",
                        "Questions are written for study practice and are not actual NAPLEX items. Domain names and exam weights come from the NAPLEX Content Outline effective May 1, 2025; weights are approximate. Topic lists are RxForge's own paraphrase of the subdomain structure.")

                section("Privacy",
                        "RxForge stores your answers and progress on this device only. There is no account, no network connection, no analytics, and no third-party SDK. Nothing you do here leaves your phone.")

                section("Medical disclaimer",
                        "RxForge is an educational study aid. It is not medical advice and must not be used to guide patient care. Always consult current primary literature and institutional guidelines in practice.")

                Divider()

                Text("NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy. RxForge is not affiliated with, endorsed by, or sponsored by NABP.")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSlate)
                    .fixedSize(horizontal: false, vertical: true)

                Text("© 2026 Karan Kohli")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSlate)
            }
            .padding(20)
        }
        .background(Color.brandBackground)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func section(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.subheadline.weight(.semibold))
            Text(body)
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack { SettingsView().environment(ProgressManager()) }
}
