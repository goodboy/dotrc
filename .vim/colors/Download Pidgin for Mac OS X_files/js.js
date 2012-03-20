(function() {
var links = document.getElementsByTagName("a"),
    counter = 0;
for(var i=0, len=links.length; i<len; ++i){
  var link = links[i];
  if (link.className === "sourceforge_accelerator_link"){
    var desc = link.innerHTML,
        clickId = "d2e3528c-68b0-11e1-b37b-0019b9f0e8fc" + (counter ? ("-" + counter.toString()) : ""),
        querystring = "?accel_key=62%3A1331164445%3Ahttp%253A//www.pidgin.im/download/mac/%3A40a4254b%2429d399999ffd0a515eaaf99ff719e0bb97e4e92e&click_id=" + clickId + "&source=accel";
    link.className = 'sourceforge_accelerator_ready'; // to prevent a double run, if the script is included again
    if (link.href.indexOf('camstudio') >= 0) {
      link.target = "_blank";
    }
    link.href += querystring;
    
    link.innerHTML = '<img src="http://a.fsdn.com/con/img/accelerator_button_large.png" alt="' + desc + '" width="316" height="55">';
    
    counter += 1;
  } else if (link.className === "sourceforge_accelerator_ready") {
    counter += 1;
  }
}
})();