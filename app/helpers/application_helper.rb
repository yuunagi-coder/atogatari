module ApplicationHelper
  def flash_bg(type)
    case type.to_sym
    when :notice then "bg-lime-200"
    when :alert then "bg-red-300"
    when :error then "bg-yellow-300"
    else "bg-gray-300"
    end
  end
end
