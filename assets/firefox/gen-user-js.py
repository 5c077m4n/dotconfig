import re
import sys
from pathlib import Path
from urllib.request import urlopen

key_value_pairs = re.compile(
    r'^\s*user_pref\((?P<key>[a-zA-Z0-9"\'._]+),\s*(?P<value>[a-zA-Z0-9"\'._]+)\)',
    re.MULTILINE,
)
response = urlopen("https://raw.githubusercontent.com/arkenfox/user.js/master/user.js")
response_raw = response.read()
userjs_origin = response_raw.decode("utf-8")

dest = Path(sys.argv[1] if len(sys.argv) > 1 else ".").joinpath("user.js").resolve()

with open(dest, "w") as userjs_final:
    print(f"Starting user.js write in '{dest}'")

    matches_iter = key_value_pairs.finditer(userjs_origin)
    for m in matches_iter:
        userjs_final.write(f"user_pref({m.group('key')}, {m.group('value')});\n")

    __dirname = Path(__file__).parent.resolve()
    overrides_path = __dirname.joinpath("user-overrides.js")

    with open(overrides_path, "r") as overrides:
        content = overrides.read()
        overrides_iter = key_value_pairs.finditer(content)

        userjs_final.write("\n\n/** OVERRIDES */\n")
        for m in overrides_iter:
            userjs_final.write(f"user_pref({m.group('key')}, {m.group('value')});\n")

    print("user.js file write complete 🤗")
