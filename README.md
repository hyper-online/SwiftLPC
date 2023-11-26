# SwiftLPC: High-Performance Linear Predictive Coding in Swift

SwiftLPC is a small library that performs Linear Predictive Coding. LPC is a powerful tool in speech processing, used for efficiently encoding the spectral characteristics of speech. 

This implementation uses Burg’s method and is essentially a conversion of the existing implementation in the (librosa)[https://librosa.org/doc/0.10.1/generated/librosa.lpc.html#librosa.lpc] python library.

With a native Swift implementation of this algorithm we can get significantly improved performance however, and the ability to run the analysis on large audio files directly on mobile devices. SwiftLPC takes full advantage of the Accelerate framework for optimal performance.

### Example Usage

```swift
let lpc = LinearPredictiveCoding()

let audioSignal: [Float] = [...]
let predictedCoefficents = lpc.computeLpc(audioSignal, order: 31)
```

### Author

- (Christian Privitelli)[https://github.com/Priva28]
