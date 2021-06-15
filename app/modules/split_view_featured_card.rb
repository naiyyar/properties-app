module SplitViewFeaturedCard
  def get_random_objects nb, searched_by, limit: 1
    return [] unless self.active.exists?
    records = self.active.reorder(Arel.sql('random()'))
    records = records.where(neighborhood: neighborhood(nb)) unless searched_by == 'nyc'
    return records.limit(limit)
  end


  private

  def neighborhood nb
    if ['Lincoln Square', 'Manhattan Valley'].include?(nb)
      'Upper West Side'
    elsif ['Carnegie Hill', 'Lenox Hill', 'Yorkville'].include?(nb)
      'Upper East Side'
    elsif lm_children.include?(nb)
      'Lower Manhattan'
    elsif NYCBorough.upper_manhattan_sub_borough.include?(nb)
      'Upper Manhattan'
    elsif harlem_sub_borough.include?(nb)
      'Harlem'
    elsif nb == 'Hudson Heights'
      'Washington Heights'
    elsif NYCBorough.midtown_manhattan_sub_borough.include?(nb) || nb == 'Midtown'
      'Midtown Manhattan'
    elsif nb == 'Sutton Place'
      'Midtown East'
    elsif brooklyn_children.include?(nb)
      'Brooklyn'
    elsif queens_children.include?(nb)
      'Queens'
    elsif bronx_children.include?(nb)
      'Bronx'
    else
      nb
    end
  end

  def harlem_sub_borough
    ['South Harlem', 'Central Harlem', 'Hamilton Heights']
  end

  def lm_children
    NYCBorough.lower_manhattan_sub_borough
  end

  def brooklyn_children
    NYCBorough.brookly_borough
  end

  def queens_children
    NYCBorough.queens_sub_borough
  end

  def bronx_children
    NYCBorough.bronx_sub_borough
  end
end