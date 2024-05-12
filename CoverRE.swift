import SwiftUI

struct CoverRE: View {
    @State private var timeRemaining = 10
    @State private var showTestPage = false
    var leScore: Int  // Score from TestPageViewLE

    var body: some View {
        NavigationStack {
            VStack {
                Text("Cover your right eye")
                    .font(.largeTitle)
                ProgressBar(value: $timeRemaining)
                    .frame(width: 300, height: 20)
                NavigationLink(destination: TestPageViewRE(leScore: leScore), isActive: $showTestPage) { EmptyView() }
            }
            .onAppear {
                startCountdown()
            }
        }
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
                self.showTestPage = true  // Trigger the NavigationLink when countdown ends
            }
        }
    }
}

