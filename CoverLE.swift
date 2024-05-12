import SwiftUI

struct CoverLE: View {
    @State private var timeRemaining = 10
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Cover your left eye")
                    .font(.largeTitle)
                ProgressBar(value: $timeRemaining)
                    .frame(width: 300, height: 20)
                NavigationLink(destination: TestPageViewLE(), isActive: $isActive) { EmptyView() }
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
                self.isActive = true // This triggers the navigation
            }
        }
    }
}

