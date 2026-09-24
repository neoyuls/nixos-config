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

The system-wide base16 palette lives in `assets/cdmx-jogorman.yaml` (polarity `light`),
sampled from `assets/wallpapers/cdmx_jogorman.jpg` — Jorge González Camarena's
*La Ciudad de México* mural. `system/default.nix` points Stylix at both.

The full list of hand-themed files (and the few deliberately left alone, such as the
Miku Firefox theme and zathura's forced B&W recolor) is documented in the header
comment of `home/home.nix`.

### Reverting the theme

`pre-cdmx-theme` tags the last commit before this theme was introduced:

```bash
git checkout pre-cdmx-theme     # inspect the previous state
nixos-rebuild switch --flake .#$(hostname)
```

To go back to the mural theme afterwards, check out your working branch again. The old
`assets/miku-stars.yaml` and `assets/miku-stars.tmTheme` are still in the tree and are
never deleted, so the previous scheme can also be re-activated by pointing
`stylix.base16Scheme` back at them.
