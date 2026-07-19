## Setup

This flake reads machine-specific identifiers (username, hostname, git name/email) from
`local.nix`, which is gitignored and never committed. A placeholder template lives at
`local.nix.example`.

On a fresh clone:

```bash
cp local.nix.example local.nix
$EDITOR local.nix
