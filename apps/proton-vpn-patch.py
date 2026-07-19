import glob, os, sys

files = glob.glob(sys.argv[1] + "/lib/python*/site-packages/proton/vpn/app/gtk/services/reconnector/session_monitor.py")
if not files:
    print("proton-vpn-patch: ERROR: session_monitor.py not found under " + sys.argv[1], file=sys.stderr)
    sys.exit(1)

for p in files:
    with open(p) as f:
        src = f.read()

    # Patch enable(): don't crash when seat/auto is absent (seatd sessions)
    patched = src.replace(
        "        if not self._session_object_path:\n"
        "            self._setup()\n"
        "\n"
        "        self._signal_receiver",
        "        if not self._session_object_path:\n"
        "            try:\n"
        "                self._setup()\n"
        "            except Exception as e:\n"
        "                import logging as _log\n"
        "                _log.getLogger(__name__).warning(\n"
        "                    'Session monitoring unavailable (no logind seat): %s', e)\n"
        "                return\n"
        "\n"
        "        self._signal_receiver",
    )
    if patched == src:
        print("proton-vpn-patch: ERROR: enable() patch did not apply to " + p, file=sys.stderr)
        sys.exit(1)
    src = patched

    # Patch is_session_unlocked: return True (assume unlocked) when seat absent
    patched = src.replace(
        '    def is_session_unlocked(self):\n'
        '        """Returns True if the user session is unlocked or False otherwise."""\n'
        "        if not self._session_object_path:\n"
        "            self._setup()\n",
        '    def is_session_unlocked(self):\n'
        '        """Returns True if the user session is unlocked or False otherwise."""\n'
        "        if not self._session_object_path:\n"
        "            try:\n"
        "                self._setup()\n"
        "            except Exception:\n"
        "                return True\n"
        "        if not self._session_object_path:\n"
        "            return True\n",
    )
    if patched == src:
        print("proton-vpn-patch: ERROR: is_session_unlocked() patch did not apply to " + p, file=sys.stderr)
        sys.exit(1)
    src = patched

    tmp = p + ".tmp"
    with open(tmp, "w") as f:
        f.write(src)
    os.replace(tmp, p)

print("proton-vpn: patched session_monitor.py for missing logind seat")
