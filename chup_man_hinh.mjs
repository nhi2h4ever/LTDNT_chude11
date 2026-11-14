// node cdp.mjs <lệnh>...   lệnh: open URL | shot FILE | click X Y | wait MS
const list = await (await fetch('http://127.0.0.1:9333/json')).json();
const page = list.find(t => t.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise(r => ws.onopen = r);
let id = 0; const pending = new Map();
ws.onmessage = e => { const m = JSON.parse(e.data); if (m.id && pending.has(m.id)) { pending.get(m.id)(m); pending.delete(m.id); } };
const send = (method, params = {}) => new Promise(r => { const i = ++id; pending.set(i, r); ws.send(JSON.stringify({ id: i, method, params })); });
const sleep = ms => new Promise(r => setTimeout(r, ms));
const fs = await import('node:fs');
await send('Emulation.setDeviceMetricsOverride', { width: 420, height: 560, deviceScaleFactor: 2, mobile: false });
const a = process.argv.slice(2);
for (let i = 0; i < a.length; i++) {
  const c = a[i];
  if (c === 'open') { await send('Page.navigate', { url: a[++i] }); await sleep(6000); }
  else if (c === 'wait') await sleep(+a[++i]);
  else if (c === 'click') {
    const x = +a[++i], y = +a[++i];
    await send('Input.dispatchMouseEvent', { type: 'mouseMoved', x, y, buttons: 0 });
    await send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', buttons: 1, clickCount: 1 });
    await sleep(60);
    await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', buttons: 0, clickCount: 1 });
    await sleep(900);
  } else if (c === 'shot') {
    const r = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync(a[++i], Buffer.from(r.result.data, 'base64'));
  }
}
ws.close();
