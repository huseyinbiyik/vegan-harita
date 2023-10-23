module ReviewsHelper
  def time_in_words(review)
    time_difference = Time.current - review.created_at

    if time_difference < 1.day
      # If the review was created less than a day ago, show the time
      review.created_at.strftime('%I:%M %p')
    elsif time_difference < 7.days
      # If the review was created less than a week ago, show how many days ago
      "#{time_ago_in_words(review.created_at)} önce"
    else
      # If the review was created more than a week ago, show the date
      review.created_at.strftime('%B %d, %Y')
    end
  end

  def average_rating(reviews)
    return 'Henüz değerlendirme yapılmamış.' if reviews.blank?

    "#{number_with_precision(reviews.average(:rating), precision: 1)}/5"
  end
end
