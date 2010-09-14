function mhnChartingMain()
{
  var serverLocation = "http://dev.mhnltd.co.uk:3000";
  var div = document.createElement('div');
  var body = document.getElementsByTagName('body')[0];

  var goals = getGoals();

  // stubbed, for now.
  var name = "fred";
  //var key = "";

  setForm(div, serverLocation, name, goals);

  formBodyField = div.getElementsByTagName('textarea')[0];
  formBodyField.value = "yatta yatta";

  body.appendChild(div);
}

/*
 * Retrieves the goals for this user, as an array of indexed strings.
 */
function getGoals()
{
  return [["0","jhdsahj"], ["1", "kjsdfi"], ["2", "qweur"]];
}


/**
 * Initialise form for div.
 */
function setForm(div, serverLocation, name, goals)
{
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
    "<form action=\"" + serverLocation + "/notes\" method=\"post\">" +

    "<input type=\"hidden\" name=\"user[name]\" value=\"" + name + "\" />" +

    //"<input type=\"hidden\" name=\"notes[key]\" value=\"" + key + "\" />" +

    "<input type=\"hidden\" name=\"source[location]\" value=\"" +
    document.location.href + "\" />" +

    "<input type=\"hidden\" name=\"source[doctype]\" value=\"webpage\" />" +

    "<label for=\"notes[title]\">Title: </label>" +
    "<input type=\"text\" name=\"source[title]\" value=\"" +
    document.title +
    "\"/><br />" +

    "<label for=\"notes[body]\">Body: </label>" +
    "<textarea name=\"notes[body]\" rows=\"10\" cols=\"80\"></textarea><br />" +

    getGoalSelect(goals) + "<br />" +

    "<input type=\"submit\" value=\"Submit\">" + 
    
    "</form></p>"
}

function getGoalSelect(goals)
{
    var goalSelect = 
    "<label for=\"notes[goals][]\">Goal: </label>" +
    "<select name=\"notes[goals][]\">";
    for (var i = 0; i < goals.length; i++)
    {
      goalSelect += 
        "<option value=\"" + goals[i][0] + "\">" + goals[i][1] + "</option>";
    }
    goalSelect += "</select>";
    return goalSelect;
}

function getSelText()
{
  var selectedText = "";
  if (window.getSelection)
  {
    selectedText = window.getSelection();
  }
  else if (document.getSelection)
  {
    selectedText = document.getSelection();
  }
  else if (document.selection)
  {
    selectedText = document.selection.createRange().text;
  }

  return selectedText;
}
