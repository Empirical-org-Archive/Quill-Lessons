class PracticeQuestionsController < ApplicationController

  before_action :admin!,                only: [:form, :save]
  prepend_before_action :access_token!, only: [:form, :save]

  before_action :load_record

  prepend_before_action :requires_activity_session!, except: [:form, :save]


  # display form to create / modify activities.
  def form
    if @practice_question.activity.data.nil?
      @practice_question.activity.data = {instructions: YAML.dump(''), body: YAML.dump('') }
    end
  end

  def module
    redirect_to chapter_practice_index_path(session[:uid])
  end

  def save
    @practice_question.instructions = params[:story][:instructions_as_text]
    @practice_question.body = params[:story][:body_as_text]

    unless @practice_question.save
      render :form
    end
  end


  private

  def story_params
    {instructions: params[:story][:instructions_as_text].to_yaml, body: params[:story][:body_as_text].to_yaml}
  end

  def load_record

    id = params[:uid] || params[:story][:id]

    @practice_question = Story.find(id)
    @assessment = @practice_question
  end
end
