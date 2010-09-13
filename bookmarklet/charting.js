function mhnChartingMain()
{
  var div = document.createElement('div');
  var body = document.getElementsByTagName('body')[0];

  div.style.height =          '200px';
  div.style.width =           '400px';
  div.style.marginLeft =      '-200px';   // offset the width for centering.
  div.style.position =        'fixed';
  div.style.backgroundColor = '#aaaaaa';  // grey
  div.style.zIndex =          '1337';     // on top of other DIVs
  div.style.top =             '0';        // at top of the screen
  div.style.left =            '50%';      // centered

  div.innerHTML = "OMG HIYA!";

  body.appendChild(div);
}
