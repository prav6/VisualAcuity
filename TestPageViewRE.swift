import SwiftUI

struct TestPageViewRE: View {
    @StateObject private var speechRecognizerManager = SpeechRecognizerManager()
    @State private var currentStageIndex = 0
    @State private var imageIndex = 0
    @State private var correctCount = 0
    @State private var score = 0
    @State private var showTestCompleted = false
    @State private var timeRemaining = 10
    @State private var timer: Timer?
    @State private var navigateToResults = false // Navigation to results view
    var leScore: Int // Score from the left eye test passed in from CoverRE

    // Visual acuity stages with sizes for scaling and directions
    let visualAcuityStages = [
        (acuity: "20/200", size: 350.0, directions: ["up", "down", "left", "right"].shuffled()),
        (acuity: "20/126", size: 200.0, directions: ["up", "down", "left", "right"].shuffled()),
        (acuity: "20/80", size: 140.0, directions: ["up", "down", "left", "right"].shuffled()),
        (acuity: "20/50", size: 100.0, directions: ["up", "down", "left", "right"].shuffled()),
        (acuity: "20/32", size: 50.0, directions: ["up", "down", "left", "right"].shuffled()),
        (acuity: "20/20", size: 30.0, directions: ["up", "down", "left", "right"].shuffled())
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if !showTestCompleted {
                    VStack {
                        Image(visualAcuityStages[currentStageIndex].directions[imageIndex]) // Show the current direction image
                            .resizable()
                            .scaledToFit()
                            .frame(width: visualAcuityStages[currentStageIndex].size, height: visualAcuityStages[currentStageIndex].size)
                        Text("Say the direction of the E (\(visualAcuityStages[currentStageIndex].acuity))")
                        ProgressBar(value: $timeRemaining)
                            .frame(height: 20)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Test Completed. Your Score: \(score) - Vision Level Achieved: \(visualAcuityStages[currentStageIndex].acuity) with \(correctCount)/4")
                        .padding()
                    NavigationLink( destination: ResultsView(leftEyeResult: "\(leScore)", rightEyeResult: "\(score)"), isActive: $navigateToResults) { EmptyView() }
                        .hidden()
                        .onAppear {
                            self.navigateToResults = true
                        }
                }

                Text("Last Command: \(speechRecognizerManager.lastSpokenWord)")
            }
            .onAppear {
                startTest()
            }
            .navigationTitle("E Direction Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func startTest() {
        speechRecognizerManager.checkPermissions { authorized in
            if authorized {
                try? speechRecognizerManager.startListening()
                setupTimer()
            } else {
                print("Permission to use microphone and speech recognition was denied.")
            }
        }
    }
    
    
    
    

    private func setupTimer() {
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                evaluateCompletion()
            }
        }
    }

    private func evaluateCompletion() {
        if speechRecognizerManager.lastSpokenWord.lowercased() == visualAcuityStages[currentStageIndex].directions[imageIndex] {
            correctCount += 1
            score += 1
            if correctCount == 4 { // All directions correctly identified
                if currentStageIndex < visualAcuityStages.count - 1 {
                    currentStageIndex += 1
                    correctCount = 0
                    imageIndex = 0
                    resetForNextStage()
                } else {
                    showTestCompleted = true
                    speechRecognizerManager.stopListening()
                }
            } else {
                imageIndex = (imageIndex + 1) % 4
                resetForNextStage()
            }
        } else {
            showTestCompleted = true  // End test on first incorrect response
            timer?.invalidate()
            speechRecognizerManager.stopListening()
        }
    }

    private func resetForNextStage() {
        speechRecognizerManager.lastSpokenWord = ""
        timeRemaining = 10
        timer?.invalidate()
        setupTimer()
        try? speechRecognizerManager.startListening()
    }
}



