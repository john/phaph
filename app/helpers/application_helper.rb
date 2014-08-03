module ApplicationHelper
  
  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end
  
  def dropbox_url( service_path )
    "https://www.dropbox.com/home#{ File.dirname( service_path ) }"
  end
  
end
