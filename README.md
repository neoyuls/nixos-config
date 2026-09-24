## Setup

This flake reads machine-specific identifiers (username, hostname, git name/email) from
`local.nix`, which is gitignored and never committed. A placeholder template lives at
`local.nix.example`.

On a fresh clone:

```bash
cp local.nix.example local.nix
$EDITOR local.nix
```

## Theming

The system-wide base16 palette lives in `assets/miku-stars.yaml` (polarity `dark`),
derived from the Sleeping Miku Animated Firefox theme and `assets/wallpapers/miku-stars.jpg`.
`system/default.nix` points Stylix at both. The full list of hand-themed files (and the
few deliberately left alone, such as the Miku Firefox theme and zathura's forced B&W
recolor) is documented in the header comment of `home/home.nix`.

### The previous mural scheme

`assets/cdmx-jogorman.yaml` and `assets/cdmx-jogorman.tmTheme` are the light palette
sampled from `assets/wallpapers/cdmx_jogorman.jpg`. They were introduced by commit
`8fd3a12`, which also introduced this colour scheme; tag `pre-cdmx-theme` marks the
state just before it. The mural assets are intentionally kept in the tree even though
nothing references them now, so that scheme can be re-activated by pointing
`stylix.base16Scheme`/`stylix.image` back at them and redoing the hand edits in the
files listed in `home/home.nix`.
