//
//  DebugPaywallOverrides.swift
//  SuperwallKit
//
//  Created by Konrad Roj on 04/08/2026.
//

import Foundation

struct DebugPaywallOverrides: Equatable {
  enum Appearance: String {
    case light
    case dark
    case system

    var interfaceStyle: InterfaceStyle? {
      switch self {
      case .light:
        return .light
      case .dark:
        return .dark
      case .system:
        return nil
      }
    }
  }

  static let attributePrefix = "attr_"

  var freeTrialOverride: Bool?
  var appearance: Appearance?
  var localeIdentifier: String?
  var attributes: [String: String]
  var shouldPresent: Bool

  var isEmpty: Bool {
    freeTrialOverride == nil
      && appearance == nil
      && localeIdentifier == nil
      && attributes.isEmpty
      && !shouldPresent
  }

  init(
    freeTrialOverride: Bool? = nil,
    appearance: Appearance? = nil,
    localeIdentifier: String? = nil,
    attributes: [String: String] = [:],
    shouldPresent: Bool = false
  ) {
    self.freeTrialOverride = freeTrialOverride
    self.appearance = appearance
    self.localeIdentifier = localeIdentifier
    self.attributes = attributes
    self.shouldPresent = shouldPresent
  }

  init(url: URL) {
    switch SWDebugManagerLogic.getQueryItemValue(fromUrl: url, withName: .trialState)?.lowercased() {
    case "eligible":
      freeTrialOverride = true
    case "ineligible":
      freeTrialOverride = false
    default:
      freeTrialOverride = nil
    }

    if let value = SWDebugManagerLogic.getQueryItemValue(fromUrl: url, withName: .appearance)?.lowercased() {
      appearance = Appearance(rawValue: value)
    } else {
      appearance = nil
    }

    if let value = SWDebugManagerLogic.getQueryItemValue(fromUrl: url, withName: .locale),
      !value.isEmpty {
      localeIdentifier = value
    } else {
      localeIdentifier = nil
    }

    if let value = SWDebugManagerLogic.getQueryItemValue(fromUrl: url, withName: .present)?.lowercased() {
      shouldPresent = ["true", "1", "yes"].contains(value)
    } else {
      shouldPresent = false
    }

    attributes = Self.parseAttributes(from: url)
  }

  private static func parseAttributes(from url: URL) -> [String: String] {
    guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
      return [:]
    }
    var result: [String: String] = [:]
    for item in queryItems where item.name.hasPrefix(attributePrefix) {
      let key = String(item.name.dropFirst(attributePrefix.count))
      if !key.isEmpty,
        let value = item.value {
        result[key] = value
      }
    }
    return result
  }
}
