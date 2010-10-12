// http://railscasts.com/episodes/114-endless-page
// http://www.railsillustrated.com/screencast-endless-page.html
// http://codesnippets.joyent.com/posts/show/835


var currentPage = 1;
var cycle = 0;

function checkScroll() {
  cycle++; // silly hack
  if (nearBottomOfPage() && Ajax.activeRequestCount == 0 && !$('complete') && cycle > 1) {
    currentPage++;
    var url = new String();
    url = window.location;

    if (window.location.pathname =="/") {
      url = url + "posts"
    }

    new Ajax.Request(url + '.js?page=' + currentPage, {asynchronous:true, evalScripts:true, method:'get'});

  } else {
    if (!$('complete')) {
      setTimeout("checkScroll()", 250); // checks every half second, unless reached the end
    }
  }
}

Position.GetWindowSize = function(w) {
    var width,height;
    w = w ? w : window;
    this.width = w.innerWidth || (w.document.documentElement.clientWidth || w.document.body.clientWidth);
    this.height = w.innerHeight || (w.document.documentElement.clientHeight || w.document.body.clientHeight);

    return this;
}

function nearBottomOfPage(){
  var last = $$(".thumb").last().viewportOffset()[1]; // top y coordinate of last thumb
  var below_window = last - Position.GetWindowSize().height;
  return below_window < 250; // number of pixels below bottom of browser.. next page will be loaded if true
}

function $_GET(q,s) {
    s = (s) ? s : window.location.search;
    var re = new RegExp('&amp;'+q+'=([^&amp;]*)','i');
    return (s=s.replace(/^\?/,'&amp;').match(re)) ?s=s[1] :s='';
}



document.observe('dom:loaded', checkScroll);

