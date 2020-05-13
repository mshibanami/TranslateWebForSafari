document.addEventListener(
    'selectionchange',
    () => {
        safari.extension.dispatchMessage(
            'selectionChanged',
            { "selectedText": document.getSelection().toString() });
    });

safari.self.addEventListener(
    'message',
    (event) => {
        if (event.name == 'openURL') {
            window.location.href = event.message.url;
        }
    },
    false);

