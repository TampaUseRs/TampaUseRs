/*
This script is intended to fix the overlapping navbar problem when it wraps and covers up the content in the container below it. 

https://stackoverflow.com/questions/14735274/bootstrap-css-hides-portion-of-container-below-navbar-navbar-fixed-top

*/
var onResize = function() {
  // apply dynamic padding at the top of the body according to the fixed navbar height
  $("body").css("padding-top", $(".navbar-fixed-top").height());
  console.log("onResize() called.");
};

// attach the function to the window resize event
$(window).resize(onResize);

// call it also when the page is ready after load or reload
$(function() {
  onResize();
  
});