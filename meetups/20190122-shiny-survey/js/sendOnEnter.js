// This script just listens for "enter"s on the text input and simulates
// clicking the "send" button when that occurs. Totally optional.
jQuery(document).ready(function(){
  jQuery('#sec1Comment').keypress(function(evt){
    if (evt.keyCode == 13){
      jQuery('#sec1CommentButton').click(); // Enter, simulate clicking send
    }
  });
    jQuery('#sec2Comment').keypress(function(evt){
    if (evt.keyCode == 13){
      jQuery('#sec2CommentButton').click(); // Enter, simulate clicking send
    }
  });
});

// We don't yet have an API to know when an element is updated, so we'll poll
// and if we find the content has changed, we'll scroll down to show the new
// comments.
var oldContent = null;
window.setInterval(function() {
  var elem = document.getElementById('sec1CommentsAll');
  if (oldContent != elem.innerHTML){
    // Scroll to the bottom of the text window.
    elem.scrollTop = elem.scrollHeight; //TODO Reactive variable.
  }
  oldContent = elem.innerHTML;  
}, 300);

var oldContent1 = null;
window.setInterval(function() {
  var elem = document.getElementById('sec2CommentsAll');
  if (oldContent1 != elem.innerHTML){
    // Scroll to the bottom of the text window.
    elem.scrollTop = elem.scrollHeight; //TODO Reactive variable.
  }
  oldContent1 = elem.innerHTML;  
}, 300);