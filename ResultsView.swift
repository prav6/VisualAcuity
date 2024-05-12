import SwiftUI

struct ResultsView: View {
    var leftEyeResult: String
    var rightEyeResult: String
    @Environment(\.presentationMode) var presentationMode
    
    func visualAcuity(score: Int) -> (acuity: String, description: String, category: String) {
        switch score {
        case 0..<4:
            return ("<20/200", "This level indicates severe vision loss, often categorized as legally blind.", "Visually Impaired")
        case 4..<8:
            return ("20/200", "At this level, vision is considered severely impaired, often meeting criteria for legal blindness.", "Visually Impaired")
        case 8..<12:
            return ("20/126", "Vision at this level is significantly impaired, and it significantly affects daily functioning.", "Visually Impaired")
        case 12..<16:
            return ("20/80", "This vision level is below average and may indicate mild vision loss or impairment.", "Okay Vision")
        case 16..<20:
            return ("20/50", "While not perfect, vision at this level is relatively good and only slightly impaired.", "Good Vision")
        case 20..<24:
            return ("20/32", "This is close to normal visual acuity but slightly impaired. Fine print may be hard to read.", "Good Vision")
        case 24:
            return ("20/20", "This represents perfect or near-perfect vision.", "Perfect Vision")
        default:
            return ("Unknown", "An error occurred, and the score is outside the expected range.", "Error")
        }
    }

    var body: some View {
        let leftScore = Int(rightEyeResult) ?? 0
        let rightScore = Int(leftEyeResult) ?? 0
        NavigationStack{
            VStack {
                HStack(spacing: 20) {
                    EyeResultView(score: leftScore, eye: "Left")
                    EyeResultView(score: rightScore, eye: "Right")
                }
                .padding()
                
                
                NavigationLink("Home", destination: MainView())
                NavigationLink("Attempt Test again", destination: CalibrationView())
            }
            .navigationTitle("Visual Acuity Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct EyeResultView: View {
    var score: Int
    var eye: String
    @State private var showDetails = false
    
    var body: some View {
        let total = 24
        let result = ResultsView(leftEyeResult: "0", rightEyeResult: "0").visualAcuity(score: score)
        
        VStack {
            Text("\(eye) Eye")
                .font(.headline)
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(Double(score) / Double(total)))
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(score >= 20 ? .green : (score >= 12 ? .yellow : .red))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: score)
                
                Text("\(Int(Double(score) / Double(total) * 100))%")
                    .font(.title)
                    .bold()
            }
            .frame(width: 100, height: 100)
            
            Text(result.acuity)
                .font(.caption)
                .padding(.top, 4)
            
            Button(action: {
                showDetails.toggle()
            }) {
                Image(systemName: "info.circle")
            }
            .popover(isPresented: $showDetails) {
                VStack {
                    Text(result.acuity)
                        .font(.headline)
                    Text(result.description)
                        .padding()
                }
            }
            
            Text(result.category)
                .font(.subheadline)
                .foregroundColor(score >= 20 ? .green : (score >= 12 ? .yellow : .red))
        }
        .padding()
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(leftEyeResult: "18", rightEyeResult: "24")
    }
}

