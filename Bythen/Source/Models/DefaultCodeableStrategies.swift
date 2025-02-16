//
//  DefaultCodeableStrategies.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import Foundation
import BetterCodable

struct ZeroInt64: DefaultCodableStrategy {
    static var defaultValue: Int64 { return 0 }
}

struct EmptyString: DefaultCodableStrategy {
    static var defaultValue: String { return "" }
}

struct ZeroDouble: DefaultCodableStrategy {
    static var defaultValue: Double { return 0.0 }
}

extension ByteData: DefaultCodableStrategy {
    static var defaultValue: ByteData { return ByteData() }
}

extension ByteColorMode: DefaultCodableStrategy {
    static var defaultValue: ByteColorMode { return .light }
}

extension ByteImage: DefaultCodableStrategy {
    static var defaultValue: ByteImage { return ByteImage() }
}

extension BackgroundType: DefaultCodableStrategy {
    static var defaultValue: BackgroundType { return BackgroundType.color }
}

extension ByteGender: DefaultCodableStrategy {
    static var defaultValue: ByteGender { return .empty }
}

typealias DefaultZeroInt64 = DefaultCodable<ZeroInt64>
typealias DefaultEmptyString = DefaultCodable<EmptyString>
typealias DefaultZeroDouble = DefaultCodable<ZeroDouble>
typealias DefaultByteData = DefaultCodable<ByteData>
typealias DefaultByteColorMode = DefaultCodable<ByteColorMode>
typealias DefaultByteImage = DefaultCodable<ByteImage>
typealias DefaultBackgroundType = DefaultCodable<BackgroundType>
typealias DefaultEmptyByteGender = DefaultCodable<ByteGender>

