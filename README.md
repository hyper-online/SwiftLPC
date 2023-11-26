# SwiftLPC: High-Performance Linear Predictive Coding in Swift

SwiftLPC is a small library that performs Linear Predictive Coding. LPC is a powerful tool in speech processing, used for efficiently encoding the spectral characteristics of speech. SwiftLPC takes full advantage of the Accelerate framework for optimal performance.

This implementation uses Burg’s method and is essentially a conversion of the existing implementation in the [librosa](https://librosa.org/doc/0.10.1/generated/librosa.lpc.html#librosa.lpc) Python library.

With a native Swift implementation of this algorithm we can get significantly improved performance, and the ability to run analysis on large audio files directly on mobile devices.

### Example Usage

```swift
import SwiftLPC

let lpc = LinearPredictiveCoding()

let audioSignal: [Float] = [...]
let predictedCoefficents = lpc.computeLpc(audioSignal, order: 31)
```

### Benchmarks

Running on a 1 minute wav file on a 10-core M1 Pro.

* librosa: ~165ms
* SwiftLPC: ~60ms

2.75x speed improvement.

### Author

- [Christian Privitelli](https://github.com/Priva28) ([@priva28_](https://twitter.com/priva28_))
