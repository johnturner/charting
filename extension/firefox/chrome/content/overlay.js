var charting = {
  loadGoals: function() {
    var url = "http://localhost:3000/goals.json";
    var request = new XMLHttpRequest();
    request.open("GET", url, true);
    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 200) {
          charting.removeGoalMenuItems();

          var goalsString = request.responseText;
          var goalsJSON = JSON.parse(goalsString);
          var goalsOut = [];
          for (var i in goalsJSON) {
            goalsOut[i] = goalsJSON[i].goal.name;
          }
          charting.goals = goalsOut;
          
          charting.addGoalMenuItems();
        }
        else {
          alert("Couldn't load notes: " + request.status);
        }
      }
    }

    request.send(null);
  },

  addGoalMenuItems: function() {
    var context_menu = document.getElementById("contentAreaContextMenu");
    var charting_end = document.getElementById("charting-end");
    for (goal in charting.goals) {
      var menu_item = createTagMenuItem(goal, charting.goals[goal]);
      context_menu.insertBefore(menu_item, charting_end);
    }
  },

  removeGoalMenuItems: function() {
    for (i in this.goals) {
      var menuItem = document.getElementById('goal-menu-item' + i);
      menuItem.parentNode.removeChild(menuItem);
    }
  },

  onLoad: function() {
    // initialization code
    this.initialized = true;
    this.strings = document.getElementById("charting-strings");
  },

  note: function(goalIndex) {
    var selection = escape(content.window.getSelection());
    var source_url = escape(content.window.location.toString());
    var source_title = escape(content.document.title);

    var params= "note[body]=" + selection +
                "&note[goal]=" + charting.goals[goalIndex] +
                "&source[location]=" + source_url +
                "&source[title]=" + source_title +
                "&source[doctype]=webpage";

    var request = new XMLHttpRequest();
    request.open("POST", "http://localhost:3000/notes.json", true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);

    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        if (request.status == 201) {
          alert("Created note for " + charting.goals[goalIndex]);
        }
        else {
          alert("Failed to create note.");
        }
      }
    }

    request.send(params);
  },

  onToolbarOptionsButtonCommand: function(e) {
    alert("Options!");
  },

  onToolbarNoteButtonCommand: function(e) {
    alert("Note!");
  }
};

window.addEventListener("load", charting.onLoad, false);
