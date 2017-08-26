# Titanium EXIF-Tools

## Example
```js
var EXIF = require('ti.exiftools');

var win = Ti.UI.createWindow({
  backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
  title: 'Get EXIF-data'
});

btn.addEventListener('click', function() {
  EXIF.scanEXIFDataFromImage({
    image: Ti.Filesystem.getFile('test.jpg').read(),
    tags: [271],
    callback: function(e) {
      Ti.API.warn(e.exif);
    }
  });
});

win.add(btn);
win.open();
```
