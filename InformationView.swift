import SwiftUI

struct InformationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("About the App")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                
                Text("Self-Administered Visual Acuity Test")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                Text("This app is designed to help users assess their long-distance vision through a simple, self-administered test. It is important to note that this app is not intended to replace professional diagnostic tools used by optometrists and ophthalmologists.")
                    .padding(.bottom, 10)
                
                Text("Purpose of the App")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                
                Text("The main purpose of this application is to provide a preliminary indication of whether a person may need corrective glasses and to encourage users to seek professional advice if the results suggest a vision deficiency. The app's tests aim to determine if your vision is healthy and if there are any noticeable issues that might require further professional evaluation.")
                    .padding(.bottom, 10)
                
                Text("How it Works")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                
                Text("Users can perform the test by following on-screen instructions which will guide them through the process of checking the clarity of their vision at different distances. The test involves identifying directions of the letter 'E' displayed in various orientations and sizes. By saying the direction aloud, the app processes your responses to determine visual acuity.")
                    .padding(.bottom, 10)
                
                Text("Not a Professional Tool")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                
                Text("It's essential to understand that this app is an aid and not a certified medical device. It should not be used for self-diagnosis or as a substitute for professional healthcare advice. Always consult with a healthcare professional for accurate eye examinations and medical assessments.")
                    .padding(.bottom, 10)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("App Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InformationView()
        }
    }
}

