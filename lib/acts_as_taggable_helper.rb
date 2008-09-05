module ActsAsTaggableHelper
  # Create a link to the tag using restful routes and the rel-tag microformat
  def link_to_tag(tag)
    link_to(tag.name, tag_url(tag), :rel => 'tag')
  end
  
  # Generate a tag cloud of the top 100 tags by usage, uses the proposed hTagcloud microformat.
  #
  # Inspired by http://www.juixe.com/techknow/index.php/2006/07/15/acts-as-taggable-tag-cloud/
  def tag_cloud(options = {})
    options.assert_valid_keys(:limit, :order, :conditions)
    options.reverse_merge! :limit => 100, :order => 'taggings_count DESC'

    tags = Tag.find(:all, options).sort_by(&:name)
    
    # TODO: add option to specify which classes you want and overide this if you want?
    classes = %w(popular v-popular vv-popular vvv-popular vvvv-popular)
    
    max, min = 0, 0
    tags.each do |tag|
      max = tag.taggings_count if tag.taggings_count > max
      min = tag.taggings_count if tag.taggings_count < min
    end
    
    divisor = ((max - min) / classes.size) + 1
    
    html =    %(<div class="hTagcloud">\n)
    html <<   %(  <ul class="popularity">\n)
    tags.each do |tag|
      html << %(    <li>)
      html << link_to(tag.name, tag_url(tag), :class => classes[(tag.taggings_count - min) / divisor]) 
      html << %(</li> \n)
    end
    html <<   %(  </ul>\n)
    html <<   %(</div>\n)
  end
end