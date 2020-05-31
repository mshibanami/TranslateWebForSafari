document.addEventListener(
    'selectionchange',
    () => {
        sendSelectionToExtension();
    });

safari.self.addEventListener(
    'message',
    (event) => {
        if (event.name == 'updateSelection') {
            sendSelectionToExtension();
        } else if (event.name == 'pageTranslationGetPageText') {
            pageTranslationSendPageTextToExtension();
        } else if (event.name == 'navigate') {
            window.location = event.message.url;
        }
    },
    false);

function sendSelectionToExtension() {
    safari.extension.dispatchMessage(
        'selectionChanged',
        { "selectedText": document.getSelection().toString() });
}

function pageTranslationSendPageTextToExtension() {
    safari.extension.dispatchMessage(
        'pageTranslationPageTextDispatched',
        { "text": document.body.innerText });
}
