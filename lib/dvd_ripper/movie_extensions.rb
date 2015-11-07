module MovieExtensions
  def title_distance
    @title_distance
  end

  def title_distance=(distance)
    @title_distance = distance
  end

  def year
    Date.parse(release_date).year
  end
end
