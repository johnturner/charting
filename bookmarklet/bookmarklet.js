// USE http://ted.mielczarek.org/code/mozilla/bookmarklet.html TO REDUCE
========================================================================
// HTML Elements for injection.
var head=document.getElementsByTagName('head')[0];  // doc head
var script = document.createElement('script');      // script to inject
// MHN Charting Script Source
script.src="http://dev.mhnltd.co.uk/charting.js";
// set to true once script init is complete, to guard re-init.
var initComplete=false;
// different events + readyState states for different browsers
var initFunc = 
  function()
  {
    if
      (
        !initComplete &&
        (
          !this.readyState ||
          this.readyState == 'loaded' ||
          this.readyState == 'complete'
        )
      )
    {
      // avoid multiple triggerings due to races.
      initComplete=true;
      // call main entry function for charting.
      mhnChartingMain();
      // avoid re-init by removing reference to this func.
      script.onload = null;
      script.onreadystatechange = null;
      // remove init script element.
      head.removeChild(script);
    }
  };
script.onload = initFunc;
script.onreadystatechange = initFunc;

// add script to head of page.
head.appendChild(script);
========================================================================
