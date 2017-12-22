module ApplicationHelper

  def draft_team_sort_style(division, stage)
    if division.draft_team_sort == stage.to_s
      "btn-secondary"
    else
      "btn-outline-secondary"
    end
  end

  def show_flash
    result = ""
    flash.each do |name, msg|
      style = "alert-success"
      case name.to_sym
      when :notice
        style = "alert-success"
      when :alert
        style = "alert-danger"
      when :error
        style = "alert-danger"
      when :warning
        style = "alert-warning"
      end
      result += content_tag :div, class: "alert #{style}" do
          content_tag(:div, msg)
      end
    end
    flash.clear
    result.html_safe
  end

end
