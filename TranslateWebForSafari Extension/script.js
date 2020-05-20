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
        }
    },
    false);

function updateSelection() {
    safari.extension.dispatchMessage(
        'selectionChanged',
        { "selectedText": document.getSelection().toString() });
}
