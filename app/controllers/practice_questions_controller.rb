class PracticeQuestionsController < ApplicationController

  before_action :admin!,                only: [:form, :save]
  prepend_before_action :access_token!, only: [:form, :save]

  before_action :load_record

  prepend_before_action :requires_activity_session!, except: [:form, :save]


  # display form to create / modify activities.
  def form
    if @practice_question.activity.data.nil?
      @practice_question.activity.data = {rule_position: YAML.dump('')}
    end
  end

  def module
    redirect_to chapter_practice_index_path(session[:uid])
  end

  def save
    @practice_question.rule_position_text = params[:practice_question][:rule_position_text]

    unless @practice_question.save
      render :form
    end
  end


  private

  def load_record

    id = params[:uid] || params[:practice_question][:id]

    @practice_question = PracticeQuestion.find(id)
    @assessment = @practice_question
  end
end
