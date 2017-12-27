module ApplicationHelper

  def draft_team_sort_style(division, stage)
    if division.draft_team_sort == stage.to_s
      "btn-secondary"
    else
      "btn-outline-secondary"
    end
  end

  def display_messages(model, brief=false)
    if model && model.errors.any?
      if brief
        errors = ""
        model.errors.full_messages.each do |msg|
          errors += content_tag(:p, msg)
        end
        content_tag(:div, errors.html_safe, class: 'alert alert-danger')
      else
        errors = ""
        model.errors.full_messages.each do |msg|
          errors += content_tag(:li, msg)
        end
        content_tag(:div, content_tag(:div, "Please review the following:", class: 'alert-title') + content_tag(:ul, errors.html_safe), class: 'alert alert-danger')
      end
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
