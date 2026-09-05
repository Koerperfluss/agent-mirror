---
app: antigravity
quelle: "saschalagler/extensions/ms-python.python-2026.4.0-universal/resources/walkthrough/install-python-linux.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# Install Python on Linux

To install the latest version of Python on [Debian-based Linux distributions](https://www.debian.org/), you can create a new terminal (<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>`</kbd>) and run the following commands:


```
sudo apt-get update
sudo apt-get install python3 python3-venv python3-pip
```

For [Fedora-based Linux distributions](https://getfedora.org/), you can run the following:

```
sudo dnf install python3
```

To verify if Python was successfully installed, run the following command in the terminal:


```
python3 --version
```
