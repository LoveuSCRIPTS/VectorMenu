const resourceName = GetParentResourceName();

const body = document.body;
const btnVector3 = document.getElementById('vector3');
const btnVector4 = document.getElementById('vector4');
const container = document.getElementById('container');
const miniHelp = document.getElementById('miniHelp');

function openUI() {
    body.style.display = 'flex';
    body.style.alignItems = 'center';
    body.style.justifyContent = 'center';
    body.style.background = 'rgba(0, 0, 0, 0.6)';
    miniHelp.style.display = 'none';
    container.style.display = 'block';
}

function closeUI() {
    body.style.display = 'none';
    body.style.background = 'rgba(0, 0, 0, 0.6)';
    miniHelp.style.display = 'none';
    container.style.display = 'none';
}

function showMini() {
    body.style.display = 'block';
    body.style.background = 'transparent';
    miniHelp.style.display = 'block';
    container.style.display = 'none';
}

function hideMini() {
    miniHelp.style.display = 'none';
    body.style.display = 'none';
    body.style.background = 'rgba(0, 0, 0, 0.6)';
}

function sendChoice(type) {
    fetch(`https://${resourceName}/chooseVector`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ type }),
    }).catch(() => {});
}

btnVector3.addEventListener('click', () => {
    sendChoice('vector3');
    closeUI();
});

btnVector4.addEventListener('click', () => {
    sendChoice('vector4');
    closeUI();
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === 'open') {
        openUI();
    } else if (data.action === 'showMini') {
        showMini();
    } else if (data.action === 'hideMini') {
        hideMini();
    } else if (data.action === 'close') {
        closeUI();
    }
});

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        closeUI();
        fetch(`https://${resourceName}/closeVector`, {
            method: 'POST',
        }).catch(() => {});
    }
});
