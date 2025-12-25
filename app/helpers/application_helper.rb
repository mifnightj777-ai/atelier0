module ApplicationHelper
    def mailbox_tab_style(tab)
      case tab
      when 'accepted'
        "left: 33.3%; width: 33.3%;"
      when 'archive'
        "left: 66.6%; width: 33.3%;"
      else
        "left: 4px; width: 33.3%;"
      end
    end
end
