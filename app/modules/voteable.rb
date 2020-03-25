module Voteable
	def upvotes_count
    votes.where(vote: true).count
  end

  def downvotes_count
    votes.where(vote: false).count
  end

  def total_votes
    votes.count
  end
end