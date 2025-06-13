# PopClip Extension for Webhook

A simple PopClip extension to quickly send selected text to a specified webhook endpoint.

This extension was modified from an original version for Cubox to be a general-purpose tool.

## Features

- Captures selected text and sends it to any webhook URL you provide.
- The data is sent as a JSON payload in the format: `{"foo": "bar", "content": "THE_SELECTED_TEXT"}`.

## Installation

1.  Make sure you have [PopClip](https://www.popclip.app) installed on your macOS.
2.  Double-click the `Cubox.popclipext` file/directory to install the extension.

## Configuration

Before using the extension, you must configure it with your personal webhook URL.

1.  Inside the `Cubox.popclipext` directory, you will find a file named `config.sh.example`.
2.  Create a copy of this file and rename it to `config.sh`.
3.  Open the new `config.sh` with a text editor.
4.  Replace the placeholder `PASTE_YOUR_WEBHOOK_URL_HERE` with your actual webhook URL.
5.  Save the file.

After these steps, the extension is ready. Select any text on your screen, and the Cubox icon will appear in the PopClip bar. Click it to send the text to your configured webhook.

## For Developers

This extension uses a simple shell script (`save.sh`) to send a POST request. It requires `curl` and either `jq` or `python3` to be available on your system for creating the JSON payload. The script is easily modifiable to change the JSON structure if needed. 