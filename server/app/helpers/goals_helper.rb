module GoalsHelper

  def link_to_button(value, link, cssclass)
    "<form><input type=\"button\" class=\"" + cssclass + "\" value=\"" + value + "\" onclick = \"window.location.href='" + link + "'\"></form>"
  end
  
end # end mod