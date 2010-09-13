function mhnChartingMain()
{
  var div = document.createElement('div');
  var body = document.getElementsByTagName('body')[0];

  // stubbed, for now.
  var name = "fred";
  var key = "fredhasakeyhonestthisistotallylegit";

  div.style.height =          '300px';
  div.style.width =           '760px';
  div.style.marginLeft =      '-380px';   // offset the width for centering.
  div.style.position =        'fixed';
  div.style.backgroundColor = '#aaaaaa';  // grey
  div.style.zIndex =          '1337';     // on top of other DIVs
  div.style.top =             '0';        // at top of the screen
  div.style.left =            '50%';      // centered
  div.style.align =           'left';     // inner elements LHS aligned

  div.innerHTML =
    "<p align=\"left\">" +
    "<form action=\"http://charting.mhnltd.co.uk/notes\" method=\"post\">" +

    "<input type=\"hidden\" name=\"notes[user]\" value=\"" + name + "\" />" +

    "<input type=\"hidden\" name=\"notes[key]\" value=\"" + key + "\" />" +

    "<input type=\"hidden\" name=\"notes[location]\" value=\"" +
    document.location.href + "\" />" +

    "<input type=\"hidden\" name=\"notes[doctype]\" value=\"webpage\" />" +

    "<label for=\"notes[title]\">Title: </label>" +
    "<input type=\"text\" name=\"notes[title]\" value=\"" +
    document.title +
    "\"/><br />" +

    "<label for=\"notes[body]\">Body: </label>" +
    "<textarea name=\"notes[body]\" rows=\"10\" cols=\"80\"></textarea><br />" +

    "<label for=\"notes[goals][]\">Goal: </label>" +
    "<select name=\"notes[goals][]\">" +
    "<option value=\"1\">One</option>" +
    "<option value=\"2\">Two</option>" +
    "<option value=\"3\">Three</option>" +
    "</select><br />" +
    
    "</form></p>"

  body.appendChild(div);
}
