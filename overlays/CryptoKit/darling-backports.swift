// swift-crypto's Util/Backports.swift declares ContiguousBytes.withBytes(_:) and a byte subscript of MutableRawSpan
// only for compilers older than 6.4, whose Foundation and standard library then have them. CryptoKit is compiled
// against Darling's Foundation and standard library modules, which have neither, so with Swift 6.4 or later both are
// missing (HMAC.swift: "value of type 'H.Digest' has no member 'withBytes'", "value of type 'MutableRawSpan' has no
// subscripts"). This supplies the same declarations for those compilers.
#if compiler(>=6.4)
import Foundation

@available(macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2, visionOS 1.0, *)
extension ContiguousBytes {
    func withBytes<R>(_ body: (RawSpan) throws -> R) rethrows -> R {
        try withUnsafeBytes { try body(RawSpan(_unsafeBytes: $0)) }
    }
}

@available(macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2, visionOS 1.0, *)
extension MutableRawSpan {
    subscript(_ byteOffset: Int) -> UInt8 {
        get { unsafeLoad(fromByteOffset: byteOffset, as: UInt8.self) }
        @_lifetime(self: copy self)
        set { storeBytes(of: newValue, toByteOffset: byteOffset, as: UInt8.self) }
    }
}
#endif
