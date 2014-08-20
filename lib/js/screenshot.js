// phantom.viewportSize = {width: 800, height: 600};
// phantom.sleep(2000);
// phantom.render('http://fryolator.com');
// phantom.exit(0);

var page = require('webpage').create();
page.open('https://fryolator.com/', function() {
  page.render('github.png');
  phantom.exit();
});