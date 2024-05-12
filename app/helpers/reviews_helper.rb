module ReviewsHelper
  def time_in_words(review, action_type)
    time_difference = Time.current - review.send(action_type)

    if time_difference < 1.day
      # If the review was created less than a day ago, show the time
      I18n.l(review.send(action_type), format: :long)
    elsif time_difference < 7.days
      # If the review was created less than a week ago, show how many days ago
      "#{time_ago_in_words(review.send(action_type))} #{t('ago')}"
    else
      # If the review was created more than a week ago, show the date
      I18n.l(review.send(action_type), format: :only_date)
    end
  end
  def average_rating(reviews)
    return I18n.t("helpers.reviews_helper.not_yet_rated") if reviews.blank?

    "#{number_with_precision(reviews.average(:rating), precision: 1)}/5"
  end
end
