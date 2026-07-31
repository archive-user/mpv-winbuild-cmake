import re, sys

with open(sys.argv[1]) as f:
    url = sha_range = ""
    for line in f:
        if re.match(r'^\[', line):
            url = sha_range = ""
        elif m := re.match(r'^From (https://\S+)', line):
            url, sha_range = m.group(1), ""
        elif url and not sha_range and (m := re.match(r'^   ([0-9a-f]+)\.\.([0-9a-f]+)\s', line)):
            sha_range = (m.group(1), m.group(2))
        elif url and sha_range and line.startswith("Removing "):
            parts = url.rstrip("/").rsplit("/", 2)
            repo = parts[-2] + "/" + parts[-1]
            print(f"- {repo}: [{sha_range[0]}...{sha_range[1]}]({url}/compare/{sha_range[0]}...{sha_range[1]})")
            url = sha_range = ""
