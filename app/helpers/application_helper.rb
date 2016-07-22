module ApplicationHelper

  # point should be an array like [41.87508698, -87.66643194]
  def location_to_s(point)
    "(#{point[0]},#{point[1]})"
  end
end
