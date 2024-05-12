import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Image placeholder - replace "logo" with your actual image asset name
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.top, 20)
                
        
                
                NavigationLink(destination: InstructionView()) {
                    Text("How to Use")
                        .foregroundColor(.black) // Text color set to black for contrast
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // Button background color
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2) // Consistent shadow application
                }
                .padding(.horizontal)
                
                // Start test navigation button
                NavigationLink(destination: CalibrationView()) {
                    Text("Start Test")
                        .foregroundColor(.black) // Text color set to black for contrast
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // Button background color
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2) // Consistent shadow application
                }
                .padding(.horizontal)
                
                NavigationLink(destination: InformationView()) {
                    Text("Information")
                        .foregroundColor(.black) // Text color set to black for contrast
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // Button background color
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2) // Consistent shadow application
                }
                .padding(.horizontal)
                
               
                
                Spacer()
            }
            .navigationTitle("Self-Administered Visual Acuity Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Self-Administered Visual Acuity Test")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

