class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  # Callback
  after_create :set_statistic

  # Kaminari
  paginates_per 5 


  # Metodo de classe  
  # def self.search(page, term)
  #   Question.includes(:answers)
  #           .where("lower(description) LIKE ?", "%#{term.downcase}%")
  #           .page(page)
  # end
  
  # def self.last_questions(page)
  #   Question.includes(:answers).order('created_at desc').page(page)
  # end

  #  Scopes
  scope :_search_subject_, ->(page, subject_id){
    includes(:answers, :subject)
    .where(subject_id: subject_id)
    .page(page)
    }

  scope :_search_, ->(page, term) {
    Question.includes(:answers, :subject)
            .where("lower(description) LIKE ?", "%#{term.downcase}%")
            .page(page)
  }
  
  scope :last_questions, ->(page) {
    Question.includes(:answers, :subject).order('created_at desc').page(page)
  }

  private
  
  def set_statistic
   AdminStatistic.set_event(AdminStatistic::EVENTS[:total_users])
  end
end
