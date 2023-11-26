// created by christian privitelli on 20/10/2023

import Accelerate
import Foundation

public class LinearPredictiveCoding {
    public init() {}

    public func computeLpc(_ y: [Float], order: Int) -> [Float] {
        var arCoeffs = [Float](repeating: 0.0, count: order + 1)
        var arCoeffsPrev = [Float](repeating: 0.0, count: order + 1)

        arCoeffs[0] = 1
        arCoeffsPrev[0] = 1

        // forward and backward prediction error. used to calculate reflection coefficient.
        var fwdError = Array(y.dropFirst())
        var bwdError = Array(y.dropLast())

        var den = computeInitialDen(fwdError: fwdError, bwdError: bwdError)
        var reflectionCoefficient: Float = 0

        for i in 0 ..< order {
            reflectionCoefficient = computeReflectionCoefficient(fwdError: fwdError, bwdError: bwdError, den: den)

            swap(&arCoeffsPrev, &arCoeffs)

            for j in 1 ... (i + 1) where j < arCoeffsPrev.count && (i - j + 1) < arCoeffsPrev.count {
                var values: [Float] = [arCoeffsPrev[j], arCoeffsPrev[i - j + 1]]
                var result: Float = 0.0

                vDSP_dotpr(&values, 1, [1.0, reflectionCoefficient], 1, &result, vDSP_Length(2))

                arCoeffs[j] = result
            }

            computePredictionErrors(fwdError: &fwdError, bwdError: &bwdError, reflectionCoefficient: &reflectionCoefficient)

            den = computeUpdatedDen(
                fwdError: fwdError,
                bwdError: bwdError,
                reflectionCoefficient: reflectionCoefficient,
                den: den
            )

            // shift up forward error
            fwdError = Array(fwdError.dropFirst())
            bwdError = Array(bwdError.dropLast())
        }

        return arCoeffs
    }

    private func computeInitialDen(fwdError: [Float], bwdError: [Float]) -> Float {
        var fwdSq: Float = 0.0
        var bwdSq: Float = 0.0
        vDSP_dotpr(fwdError, 1, fwdError, 1, &fwdSq, vDSP_Length(fwdError.count))
        vDSP_dotpr(bwdError, 1, bwdError, 1, &bwdSq, vDSP_Length(bwdError.count))
        return fwdSq + bwdSq
    }

    private func computeUpdatedDen(fwdError: [Float], bwdError: [Float], reflectionCoefficient: Float, den: Float) -> Float {
        let q = 1.0 - reflectionCoefficient * reflectionCoefficient
        let lastElementBwd = bwdError.last! * bwdError.last!
        let firstElementFwd = fwdError.first! * fwdError.first!
        return q * den - (lastElementBwd + firstElementFwd)
    }

    private func computeReflectionCoefficient(fwdError: [Float], bwdError: [Float], den: Float) -> Float {
        let epsilon = Float.leastNonzeroMagnitude

        var result: Float = 0.0
        vDSP_dotpr(bwdError, 1, fwdError, 1, &result, vDSP_Length(bwdError.count))
        return -2 * result / (den + epsilon)
    }

    private func computePredictionErrors(fwdError: inout [Float], bwdError: inout [Float], reflectionCoefficient: inout Float) {
        // We need to pass the state before fwdError is modified in the first vDSP_vsma into the second vDSP_vsma that modifies bwdError.
        let fwdErrorTemp = fwdError

        /// vDSP_vsma
        // for (n = 0; n < N; ++n)
        //     D[n] = A[n]*B + C[n];
        vDSP_vsma(bwdError, 1, &reflectionCoefficient, fwdError, 1, &fwdError, 1, vDSP_Length(fwdError.count))
        vDSP_vsma(fwdErrorTemp, 1, &reflectionCoefficient, bwdError, 1, &bwdError, 1, vDSP_Length(bwdError.count))
    }
}
