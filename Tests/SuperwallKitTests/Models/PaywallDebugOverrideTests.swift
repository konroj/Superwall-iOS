//
//  PaywallDebugOverrideTests.swift
//  SuperwallKit
//
//  Created by Konrad Roj on 05/08/2026.
//
// swiftlint:disable all

import Testing
import Foundation
@testable import SuperwallKit

struct PaywallDebugOverrideTests {
  // Guards the safety invariant: `debugAttributeOverrides` is a render-only,
  // transient field and must never be encoded or persisted. If it is ever
  // added to Paywall's CodingKeys, these fail.

  @Test func debugAttributeOverrides_areNeverEncoded() throws {
    var paywall = Paywall.stub()
    paywall.debugAttributeOverrides = ["debugAttrKey": "debugAttrValue"]

    let data = try JSONEncoder().encode(paywall)
    let json = String(data: data, encoding: .utf8) ?? ""

    #expect(!json.contains("debugAttributeOverrides"), "debug overrides must not be encoded")
    #expect(!json.contains("debugAttrKey"))
    #expect(!json.contains("debugAttrValue"))
  }

  @Test func debugAttributeOverrides_areNilAfterDecoding() throws {
    var paywall = Paywall.stub()
    paywall.debugAttributeOverrides = ["debugAttrKey": "debugAttrValue"]

    let data = try JSONEncoder().encode(paywall)
    let decoded = try JSONDecoder().decode(Paywall.self, from: data)

    #expect(decoded.debugAttributeOverrides == nil)
  }
}
