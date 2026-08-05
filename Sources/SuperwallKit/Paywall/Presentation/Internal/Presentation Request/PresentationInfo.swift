//
//  File.swift
//  
//
//  Created by Yusuf Tör on 03/05/2022.
//

import Foundation

/// Contains information about the presentation of a paywall.
enum PresentationInfo {
  case implicitTrigger(PlacementData)
  case explicitTrigger(PlacementData)

  /// Only used in the `DebugViewController`
  case fromIdentifier(_ identifier: String, freeTrialOverride: Bool, attributeOverrides: [String: String])

  var freeTrialOverride: Bool? {
    switch self {
    case .fromIdentifier(_, let freeTrialOverride, _):
      return freeTrialOverride
    default:
      return nil
    }
  }

  /// Debugger-only user-attribute overrides, applied to the presented paywall's render only.
  var attributeOverrides: [String: String]? {
    switch self {
    case .fromIdentifier(_, _, let attributeOverrides):
      return attributeOverrides
    default:
      return nil
    }
  }

  var placementData: PlacementData? {
    switch self {
    case let .implicitTrigger(placementData),
      let .explicitTrigger(placementData):
      return placementData
    default:
      return nil
    }
  }

  var placementName: String? {
    switch self {
    case let .implicitTrigger(placementData),
      let .explicitTrigger(placementData):
      return placementData.name
    case .fromIdentifier:
      return nil
    }
  }

  var identifier: String? {
    switch self {
    case .fromIdentifier(let identifier, _, _):
      return identifier
    default:
      return nil
    }
  }
}
