(function () {
    document.addEventListener(
        'selectionchange',
        () => {
            if (document.hidden) {
                return;
            }
            sendSelectionToExtension();
        });

    document.addEventListener(
        'keydown',
        (event) => {
            if (document.hidden) {
                return;
            }
            sendKeydownToExtension(event);
        },
        false);

    safari.self.addEventListener(
        'message',
        (event) => {
            if (document.hidden) {
                return;
            }
            switch (event.name) {
                case 'updateSelection':
                    sendSelectionToExtension();
                    break;
            }
        },
        false);

    if (window.top === window) {
        safari.self.addEventListener(
            'message',
            (event) => {
                if (document.hidden) {
                    return;
                }
                switch (event.name) {
                    case 'pageTranslationGetPageTextSample':
                        pageTranslationSendPageTextSampleToExtension();
                        break;
                    case 'navigate':
                        window.location = event.message.url;
                        break;
                }
            },
            false);
    }

    function sendSelectionToExtension() {
        safari.extension.dispatchMessage(
            'selectionChanged',
            { "selectedText": document.getSelection().toString() });
    }

    function pageTranslationSendPageTextSampleToExtension() {
        const text = (
            document.querySelector("article")
            ?? document.querySelector("section")
            ?? document.body
        ).innerText
        safari.extension.dispatchMessage(
            'pageTranslationPageTextDispatched',
            { "text": text });
    }

    function sendKeydownToExtension(event) {
        const modifierKeys = ["Meta", "Shift", "Alt", "Control"]
        if (modifierKeys.includes(event.key)) {
            return;
        }
        safari.extension.dispatchMessage(
            'shortcutReceived',
            {
                'key': event.key,
                'isCommandPressed': event.metaKey,
                'isShiftPressed': event.shiftKey,
                'isControlPressed': event.ctrlKey,
                'isOptionPressed': event.altKey,
            });
    }
})();
