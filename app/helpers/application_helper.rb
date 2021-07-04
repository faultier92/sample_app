module ApplicationHelper
  def full_title(page_title = nil, base_title = nil)
    base_title ||= 'Sample app'
    page_title ? page_title + ' | ' + base_title : base_title
  end
end
