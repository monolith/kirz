// http://railscasts.com/episodes/114-endless-page
// http://www.railsillustrated.com/screencast-endless-page.html
// http://codesnippets.joyent.com/posts/show/835


var currentPage = 1;
var cycle = 0;

function checkScroll() {
  cycle++; // silly hack
  if (nearBottomOfPage() && Ajax.activeRequestCount == 0 && !$('complete') && cycle > 1) {

  var next = $('nextColumn').value + "_y";
  var scroll = document.viewport.getScrollOffsets()[1];

  var below_window = parseInt($(next).value) - scroll;

    currentPage++;
    var url = new String();
    url = document.URL;

    if (window.location.pathname =="/") {
      url = url + "posts"
    }

    var tmp = new Array();


    tmp = url.split("?");

    if (document.URL.indexOf("?") <0){
      tmp[1] = "";
    }
    else {
      tmp[1] = tmp[1] + "&";
    }

    var column1_x = document.getElementById('column1_x').value;
    var column1_y = document.getElementById('column1_y').value;

    var column2_x = document.getElementById('column2_x').value;
    var column2_y = document.getElementById('column2_y').value;

    var column3_x = document.getElementById('column3_x').value;
    var column3_y = document.getElementById('column3_y').value;

    var nextColumn = document.getElementById('nextColumn').value;

    var positions = "&column1_x=" + column1_x + "&column1_y=" + column1_y;
    positions = positions + "&column2_x=" + column2_x + "&column2_y=" + column2_y;
    positions = positions + "&column3_x=" + column3_x + "&column3_y=" + column3_y;
    positions = positions + "&nextColumn=" + nextColumn;

    new Ajax.Request(tmp[0] + '.js?'+ tmp[1] + 'page=' + currentPage + positions, {asynchronous:true, evalScripts:true, method:'get'});

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
//  var last = $$(".thumb").last().viewportOffset()[1];
//  var below_window = last - Position.GetWindowSize().height;

  var next = parseInt($($('nextColumn').value + "_y").value); // y coordinate of next image position
  var scroll = document.viewport.getScrollOffsets()[1]; // top of scroll bar
  var bottom = document.viewport.getHeight() + scroll;
  var gap = document.viewport.getHeight() / 3; // allowable distance between bottom and where next is

  var distance = next - (bottom + gap);

  return distance < 0; // next page will be loaded if true
}

function $_GET(q,s) {
    s = (s) ? s : window.location.search;
    var re = new RegExp('&amp;'+q+'=([^&amp;]*)','i');
    return (s=s.replace(/^\?/,'&amp;').match(re)) ?s=s[1] :s='';
}



document.observe('dom:loaded', checkScroll);

