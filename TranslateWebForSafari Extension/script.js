document.addEventListener(
    'selectionchange',
    () => {
        updateSelection();
    });

safari.self.addEventListener(
    'message',
    (event) => {
        if (event.name == 'updateSelection') {
            updateSelection();
        } else if (event.name == 'navigate') {
            window.location = event.message.url;
        }
    },
    false);

function updateSelection() {
    safari.extension.dispatchMessage(
        'selectionChanged',
        { "selectedText": document.getSelection().toString() });
}
