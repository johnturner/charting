/**
 * JavaScript Bookmarklet Code Version 0.1A
 * Raises a div above the existing page, for the user to add notes to the
 * charting system.
 *
 * TODO:
 * - Remove goal from combobox once it is added; avoid double-addition.
 * - Make first 140 characters of Body red.
 * - Implement reset.
 * - Deal with multiple instances (avoid this happening)
 * - Handle login to charting server if session does not exist.
 * - Use API key.
 * - Handle no-goals.
 * - Extend use of JS and DOM namespace to avoid collisions with existing script
 *   or HTML.
 * - Fix layout widths: why does it work in some cases (e.g.
 *   http://chinesefood.about.com) and not others?
 * - Stop original page CSS polluting form (e.g. http://www.ducea.com)
 * - Make generally more visually appealing.
 * - Clean up this code into a single charting class/object.
 */

var serverLocation = "http://dev.mhnltd.co.uk:3000";
var goalsScript = serverLocation + "/goals.json";
var div = document.createElement('div');
var body = document.getElementsByTagName('body')[0];
// stubbed, for now.
var name = "fred";
//var key = "";

var charting =
{
  theGoals: null,
  goals: function (theGoals)
  {
    this.theGoals = theGoals;
  }
}

function mhnChartingMain()
{
  var goals = getGoals();
  // execution is continued at getGoalsBottom
}

/*
 * Retrieves the goals for this user, as an array of indexed strings.
 */
function getGoals()
{
  runScript(goalsScript, getGoalsBottom);
}

/*
 * Callback to be called once goals have been retrieved via JSONP. Finishes the
 * initialisation of the form.
 */
function getGoalsBottom()
{
  setForm(charting.theGoals);
  body.appendChild(div);

  var formBodyField = document.getElementsByName('note[body]')[0];
  formBodyField.value = getSelectedText();

}

/*
 * runs a script as specified.
 */
function runScript(src, callbackFunc)
{
  var retValue = null;
  // HTML Elements for injection.
  var head=document.getElementsByTagName('head')[0];  // doc head
  var script = document.createElement('script');      // script element
  // MHN Charting Script Source -- script to inject.
  script.src=src;
  // set to true once script init is complete, to guard re-init.
  var initComplete=false;
  // function called to initialise script after injection.
  var initFunc = 
    function()
    {
      if
        (
         !initComplete &&
         (
          !this.readyState ||
          // different readyState states for different browsers
          this.readyState == 'loaded' ||
          this.readyState == 'complete'
         )
        )
        {
          // avoid multiple triggerings due to races.
          initComplete=true;
          callbackFunc();
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
  return retValue;
}


/**
 * Initialise form for div.
 */
function setForm(goals)
{
  div.style.height =          "500px";
  div.style.width =           "760px";
  div.style.marginLeft =      "-380px";   // offset the width for centering.
  div.style.position =        "fixed";
  div.style.backgroundColor = "#aaaaaa";  // grey
  div.style.zIndex =          "1337";     // on top of other DIVs
  div.style.top =             "0";        // at top of the screen
  div.style.left =            "50%";      // centered
  div.style.textAlign =       "left";     // inner elements LHS aligned
  div.style.border =          "2px solid black";
  div.style.padding =         "10px";
  div.style.font =            "12pt Arial";
  div.style.color =           "black";
  div.style.overflow =        "auto";
  div.innerHTML =
    "<form name=\"note_add_form\" action=\"" + serverLocation + "/notes\" " +
    "method=\"post\" target=\"_blank\">" +

    "<input type=\"hidden\" name=\"user[name]\" value=\"" + name + "\" />" +

    //"<input type=\"hidden\" name=\"note[key]\" value=\"" + key + "\" />" +

    "<input type=\"hidden\" name=\"source[location]\" value=\"" +
    document.location.href + "\" />" +

    "<input type=\"hidden\" name=\"source[doctype]\" value=\"webpage\" />" +

    "Title<br/>" +
    "<input type=\"text\" name=\"source[title]\" value=\"" +
    document.title +
    "\" style=\"border: 1px solid black; font: 12pt Courier; width: 740px\" " +
    "/><br />" +

    "Body<br/>" +
    "<textarea name=\"note[body]\" " +
    "style=\"border: 1px solid black; font: 12pt Courier; width: 740px; " +
    "height: 200px\"></textarea><br />" +

    "<div id=\"added_goals\">Goals:<br/></div>" +

    getGoalSelect(goals) + "<br />" +

    "<center>" +
    "<input type=\"submit\" value=\"Submit\" " +
    "onclick=\"javascript:hideForm()\">" + 
    "<input type=\"button\" value=\"Reset\" " +
    "onclick=\"javascript:resetForm()\"/>" + 
    "<input type=\"button\" value=\"Hide\" " +
    "onclick=\"javascript:hideForm()\">" + 
    "</center>" +
    
    "</form>";
}

/**
 * Removes the div from the body, hiding the form. The form is effectively reset
 * at this point, since it will be re-initialised when the bookmarklet is
 * relaunched.
 */
function hideForm()
{
  body.removeChild(div);
}

/**
 * Takes whatever goal is currently selected and adds it to note[goals][] by
 * way of a hidden input added to the form.
 */
var numGoalsAdded = 0;
function addGoal()
{
  numGoalsAdded++;
  var addedGoals = document.getElementById('added_goals');
  var addedGoal = document.createElement('p');
  // get index of selected goal
  var goalSelect = document.getElementById("goal_select");
  var selIndex = goalSelect.selectedIndex;
  addedGoal.id = 'selected_goal_' + goalSelect.options[selIndex].value;
  addedGoal.innerHTML = goalSelect.options[selIndex].text;
  addedGoal.innerHTML += "&nbsp;&nbsp; - <a href=\"#\" " + 
    "onclick=\"javascript:removeGoal('" + addedGoal.id + "')\">remove</a>"
  goalSelect.options[selIndex].disabled = true;
  addedGoals.appendChild(addedGoal);
}

function removeGoal(goalID)
{
  var goalRemove = document.getElementById(goalID);
  var addedGoals = document.getElementById('added_goals');
  addedGoals.removeChild(goalRemove);
}

function getGoalSelect(goals)
{
    var goalSelect = 
    "<select id=\"goal_select\">";
    for (var i = 0; i < goals.length; i++)
    {
      goalSelect += 
        "<option value=\"" + goals[i].goal.id + "\">" + goals[i].goal.name +
        "</option>";
    }
    goalSelect += "</select>";
    goalSelect += "<a href=\"#\" onclick=\"javascript:addGoal()\">Add</a>";
    return goalSelect;
}

function getSelectedText()
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
