import AVFoundation
import Speech

class SpeechRecognizerManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-UK"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var lastSpokenWord = ""
    @Published var isListening = false

    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }

    func checkPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    //start listening
    func startListening() throws {
        if audioEngine.isRunning {
            stopListening()
        }
        try setupAudioEngine()
    }

    private func setupAudioEngine() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            guard let self = self else { return }
            // to micmic the snellen test it only listen for the input then stops listening to avoid confusion
            if let result = result, let lastSegment = result.bestTranscription.segments.last {
                self.lastSpokenWord = lastSegment.substring
                if ["up", "right", "down", "left"].contains(lastSegment.substring.lowercased()) {
                    self.stopListening()
                }
            }

            if error != nil || result?.isFinal == true {
                self.stopListening()
            }
        })

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
    }

    deinit {
        stopListening()
    }
}

