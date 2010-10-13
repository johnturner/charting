class JsLibController < ApplicationController
  def js_lib
    render :layout => false, :content_type => "text/javascript"
  end
end
