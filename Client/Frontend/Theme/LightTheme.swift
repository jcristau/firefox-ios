// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0

import UIKit

// This file contains the default theme for iOS, as outlined in Figma.
// While no fonts have yet been implemented, they will be part of the
// themeing system, and as such, have been roughly included.

struct LightTheme: Theme {
    var type: ThemeType = .light
    var colors: ThemeColourPalette = LightColourPalette()
}

private struct LightColourPalette: ThemeColourPalette {
// TODO: Replace with colors from the Mobile Styles Figma
    var actionPrimary: UIColor { return UIColor(named: "ActionPrimary")! }
    var actionSecondary: UIColor { return UIColor(named: "ActionSecondary")! }
    var borderDivider: UIColor { return UIColor(named: "BorderDivider")! }
    var borderSelectedDefault: UIColor { return UIColor(named: "BorderSelectedDefault")! }
    var borderSelectedPrivate: UIColor { return UIColor(named: "BorderSelectedPrivate")! }
    var controlActive: UIColor { return UIColor(named: "ControlActive")! }
    var controlBase: UIColor { return UIColor(named: "ControlBase")! }
    var iconAccentBlue: UIColor { return UIColor(named: "IconAccentBlue")! }
    var iconAccentGreen: UIColor { return UIColor(named: "IconAccentGreen")! }
    var iconAccentPink: UIColor { return UIColor(named: "IconAccentPink")! }
    var iconAccentViolet: UIColor { return UIColor(named: "IconAccentViolet")! }
    var iconAccentYellow: UIColor { return UIColor(named: "IconAccentYellow")! }
    var iconDisabled: UIColor { return UIColor(named: "IconDisabled")! }
    var iconInverted: UIColor { return UIColor(named: "IconInverted")! }
    var iconPrimary: UIColor { return UIColor(named: "IconPrimary")! }
    var iconSecondary: UIColor { return UIColor(named: "IconSecondary")! }
    var layer1: UIColor { return UIColor(named: "Layer1")! }
    var layer2: UIColor { return UIColor(named: "Layer2")! }
    var layer2Blur: UIColor { return UIColor(named: "Layer2Blur")! }
    var layer3: UIColor { return UIColor(named: "Layer3")! }
    var layer4: UIColor { return UIColor(named: "Layer4")! }
    var layerEmphasis: UIColor { return UIColor(named: "LayerEmphasis")! }
    var scrim: UIColor { return UIColor(named: "Scrim")! }
    var textDisabled: UIColor { return UIColor(named: "TextDisabled")! }
    var textInverted: UIColor { return UIColor(named: "TextInverted")! }
    var textLink: UIColor { return UIColor(named: "TextLink")! }
    var textPrimary: UIColor { return UIColor(named: "TextPrimary")! }
    var textSecondary: UIColor { return UIColor(named: "TextSecondary")! }
    var textWarning: UIColor { return UIColor(named: "TextWarning")! }
}
