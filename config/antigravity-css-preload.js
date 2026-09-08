// Antigravity IDE Custom CSS Preload
// Injects custom CSS into webContents

const fs = require('fs');
const path = require('path');
const os = require('os');

const homeDir = os.homedir();
const candidatePaths = [
  path.join(homeDir, '.config/vscode-custom-theme/css.css'),
  path.join(homeDir, 'vscode-custom.css'),
  path.join(homeDir, '.config/vscode-custom.css')
];

let cssPath = candidatePaths.find(p => fs.existsSync(p));

try {
  if (cssPath) {
    const customCSS = fs.readFileSync(cssPath, 'utf8');
    
    const injectCSS = () => {
      const { app } = require('electron');
      
      app.on('browser-window-created', (_, window) => {
        window.webContents.on('did-finish-load', () => {
          window.webContents.insertCSS(customCSS).catch(err => {
            console.error('[Antigravity Custom CSS] Failed to inject:', err);
          });
        });
      });
    };
    
    // Execute immediately if app is ready
    const { app } = require('electron');
    if (app.isReady()) {
      app.whenReady().then(injectCSS);
    } else {
      injectCSS();
    }
    
    console.log('[Antigravity Custom CSS] Injected:', cssPath);
  } else {
    console.warn('[Antigravity Custom CSS] No custom CSS file found');
  }
} catch (err) {
  console.error('[Antigravity Custom CSS] Preload error:', err);
}
