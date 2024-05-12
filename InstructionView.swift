import SwiftUI

struct InstructionView: View {
    var body: some View {
        TabView {
            // First instruction page with an image placeholder
            instructionPage(
                text: "The test is calibrated at 2 meters. Place your phone down at the mark and walk away until it says 'Hold Position.'",
                imageName: "image1"  // Replace "image1" with your actual image name in your assets
            )
            
            // Second instruction page with an image placeholder
            instructionPage(
                text: "A countdown will begin as soon as you're in position. Make sure to wear Bluetooth earphones with a microphone to pick up the audio clearly.",
                imageName: "image2"
            )
            
            // More instruction pages similarly...
            instructionPage(
                text: "Increase your screen brightness to the maximum to see the letters clearly. If you wear glasses, keep them on during the test.",
                imageName: "image3"
            )
            
            instructionPage(
                text: "The letter 'E' will be shown in various sizes and directions. Point in the direction of the 'E' and say the direction aloud: up, right, down, or left.",
                imageName: "image4"
            )
            
            instructionPage(
                text: "Ensure the test environment is quiet. The test will be administered automatically. Follow the prompts closely.",
                imageName: "image5"
            )
            
            // Final page with a button to start calibration
            VStack(spacing: 20) {
                Text("Ready to start the calibration? Press the button below and walk back to your starting position.")
                    .padding()
                
                Image(systemName: "photo")  // Replace with actual image when ready
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                
                NavigationLink(destination: CalibrationView()) {
                    Text("Activate Calibration")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationTitle("Instructions")
    }
    
    // Helper function to create instruction pages with image placeholders
    func instructionPage(text: String, imageName: String) -> some View {
        VStack(spacing: 20) {
            Image(imageName)  // Use your actual images here
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Text(text)
                .padding()
        }
    }
}



struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InstructionView()
        }
    }
}

