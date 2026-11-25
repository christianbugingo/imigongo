# Asset sources and licenses

Step 4b adds no downloaded image, sound, display font, or runtime asset package. The original-art manifest and bundled OFL display font are Step 4c work, not claimed as delivered here.

| Asset | Source | License / status |
| --- | --- | --- |
| Tile paths and tutorial diagrams | Original project code in lib/ui/painters/tile_painter.dart and normal engine-authored tutorial data | Original procedural project artwork; no third-party reference embedded, copied or traced. No project-wide redistribution license has been selected. Cultural review remains pending; no cultural meaning is asserted. |
| Stars, arrow, pause, undo, restart and help glyphs | Flutter SDK MaterialIcons font, used via Icons and uses-material-design | The installed SDK's MaterialIcons_LICENSE.txt specifies CC BY 4.0; retained verbatim in docs/licenses/MaterialIcons_LICENSE.txt. Attribution: Material Icons, distributed with Flutter; original upstream project https://github.com/google/material-design-icons. No custom icon font was downloaded. |
| Body/title text | Existing Flutter platform/default font selection; no fontFamily or new font assets | System fonts remain platform-provided. The SDK fallback Roboto font's Apache 2.0 license is retained in docs/licenses/Roboto_LICENSE.txt. No OFL display font has been added yet. |
| Temporary launcher PNGs | Restored Flutter project-template icons under ios/Runner/Assets.xcassets/AppIcon.appiconset and Android mipmap folders | Existing framework scaffold placeholder only, as approved in the Step 4b plan. Flutter template source is distributed under BSD-3-Clause; Flutter branding/trademark policy is separate. This is not the final game logo and no release branding clearance is claimed. Source: installed Flutter SDK templates, https://github.com/flutter/flutter and https://flutter.dev/brand. |
| Screenshot evidence | Screenshots of this project's running UI in docs/verification/step4b-welcome.png | Project UI capture; no third-party reference imagery. Not bundled into the app. |
| Sounds | None | Deferred to Step 6; no sound license required yet. |
| Photo-derived logo experiment | Moved to /Users/a/Documents/imigongo_reference/photo-derived-logo | Reference/adaptation provenance unverified; retired and outside the repo. No copy is bundled or intended for commit. |

`/reference/` is gitignored should local visual references be gathered later. They must stay out of app bundles, source history and asset manifests. Record exact source/license and attribution before introducing any commissioned art, OFL font or CC0/permissive sound in its approved step.

The native Flutter icons are temporary scaffolding, not a style reference for future art. The game board remains procedural. New original art must not trace or reproduce the supplied photograph.
