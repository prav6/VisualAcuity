import AVFoundation
import UIKit
import Vision

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVSpeechSynthesizerDelegate {
    private var captureSession: AVCaptureSession?
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var faceDetectionRequest: VNDetectFaceRectanglesRequest?
    private var timer: Timer?
    private var speechSynthesizer = AVSpeechSynthesizer()  // For voice countdown

    @Published var countdown: Int = 5  // Timer for UI display
    @Published var showCheckmark: Bool = false
    @Published var prompt: String = "Go further back until 2m"  // Static prompt for UI

    override init() {
        super.init()
        setupCamera()
        configureFaceDetection()
        speechSynthesizer.delegate = self
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        print("Camera started")

        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession?.canAddInput(videoInput) ?? false else {
            print("Error setting up video input.")
            return
        }

        captureSession?.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA)]
        if captureSession?.canAddOutput(videoOutput) ?? false {
            captureSession?.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        } else {
            print("Could not add video output to the session")
            return
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
    }

    private func configureFaceDetection() {
        faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            self?.handleDetectedFaces(request: request, error: error)
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    private func handleDetectedFaces(request: VNRequest, error: Error?) {
      // Print that face detection processing has begun
      print("Face detection process started")

      // Check if an error occurred during face detection
      if let error = error {
        print("Face detection failed: \(error)")
        return
      }

      // Attempt to get the results as an array of VNFaceObservation objects
      guard let results = request.results as? [VNFaceObservation], !results.isEmpty else {
        DispatchQueue.main.async {
          // No faces detected, update prompt and reset timer
          self.prompt = "No face detected"
          self.resetTimer()
        }
        return
      }

      DispatchQueue.main.async {
        // If there's at least one face, process the first one
        if let face = results.first {
          let width = face.boundingBox.width
          let distance = self.calculateDistance(faceWidth: width)

          // Update prompt based on the calculated distance
          self.prompt = distance > 190 && distance < 205 ? "Hold position" : "Go further back until 2m"

          // Start timer if within range, otherwise reset timer
          if distance > 190 && distance < 210 {
            self.startTimer()
          } else {
            self.resetTimer()
          }
        } else {
          // No faces detected, reset timer
          self.resetTimer()
        }
      }
    }

    private func calculateDistance(faceWidth: CGFloat) -> CGFloat {
      // Predefined slope based on assumed calibration data
      let slope = (200 - 50) / (0.045 - 0.165)
      // Estimate distance based on face width and slope
      return 50 + (faceWidth - 0.165) * slope
    }

    private func startTimer() {
        if timer == nil {
            countdown = 5
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        countdown = 5
        showCheckmark = false
    }

    private func updateTimer() {
        if countdown > 0 {
            let speechUtterance = AVSpeechUtterance(string: "\(countdown)")
            speechSynthesizer.speak(speechUtterance)
            countdown -= 1
        } else {
            showCheckmark = true
            timer?.invalidate()
            timer = nil
            let speechUtterance = AVSpeechUtterance(string: "Complete")
            speechSynthesizer.speak(speechUtterance)
            DispatchQueue.main.async {
                self.prompt = "Complete"
            }
        }
    }


    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
            self?.resetTimer()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Received a frame")
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer")
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .up, options: [:])
        try? imageRequestHandler.perform([self.faceDetectionRequest!])
    }
}

