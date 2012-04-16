module StaticPagesHelper

  def proper_title(address)
    split_item = address.sub('/','')
    puts split_item.to_s.capitalize
    heading = split_item.to_s.capitalize
    return heading
  end

end
