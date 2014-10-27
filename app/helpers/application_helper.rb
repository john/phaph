module ApplicationHelper
  
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
      else
       "alert #{flash_type.to_s}"
    end
  end
  
  # def dropbox_url( service_path )
  #   "https://www.dropbox.com/home#{ File.dirname( service_path ) }"
  # end

  def follow_link(model:nil)
    raise if model == nil

    if signed_in?
      if current_user.follows?(model)
        link_to '<span class="tip glyphpro glyphpro-shoe_steps"></span> &nbsp;following'.html_safe, send("unfollow_#{model.class.to_s.downcase}_path", model.id), class: 'btn btn-xs btn-default btn-follow', remote: true
      else
        link_to '<span class="tip glyphpro glyphpro-shoe_steps"></span> &nbsp;follow'.html_safe, send("follow_#{model.class.to_s.downcase}_path", model.id), class: 'btn btn-xs btn-default btn-follow', remote: true
      end
    else
      link_to '<span class="tip glyphpro glyphpro-shoe_steps"></span> &nbsp;follow'.html_safe, new_user_registration_path, class: 'btn btn-xs btn-default btn-follow', target: '_blank'
    end
  end
  
  
  
  def like_link(model:nil, show_icon:true)
    raise if model == nil

    if signed_in?
      if current_user.likes?(model)
        if show_icon
          link_to '<span class="tip glyphicon glyphicon-hand-up"></span> &nbsp;liked'.html_safe, send("unlike_#{model.class.to_s.downcase}_path", model.id), class: 'btn btn-xs btn-default btn-like', remote: true
        else
          link_to 'liked', send("unlike_#{model.class.to_s.downcase}_path", model.id), class: 'btn-like', style: 'color: #999;', remote: true
        end
      else
        if show_icon
          link_to '<span class="tip glyphicon glyphicon-thumbs-up"></span> &nbsp;like'.html_safe, send("like_#{model.class.to_s.downcase}_path", model.id), class: 'btn btn-xs btn-default btn-like', remote: true
        else
          link_to 'like', send("like_#{model.class.to_s.downcase}_path", model.id), class: 'btn-like', remote: true
        end
      end
    else
      if show_icon
        link_to '<span class="tip glyphicon glyphicon-thumbs-up"></span> &nbsp;like'.html_safe, new_user_registration_path, class: 'btn btn-xs btn-default btn-follow', target: '_blank'
      else
        link_to 'like', new_user_registration_path, target: '_blank'
      end
    end
  end
  
  
end
