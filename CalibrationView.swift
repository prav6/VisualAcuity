import SwiftUI

struct CalibrationView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var navigateToTestPage = false

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(cameraManager: cameraManager)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    if cameraManager.showCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green)
                    }

                    Text(cameraManager.prompt)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToTestPage) {
                CoverLE()
            }
            .onAppear {
                cameraManager.startSession()
            }
            .onDisappear {
                cameraManager.stopSession()
            }
            .onReceive(cameraManager.$showCheckmark) { showCheckmark in
                if showCheckmark {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigateToTestPage = true
                    }
                }
            }
            .navigationTitle("Calibration")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

