class StoriesController < ApplicationController

  before_action :admin!,                only: [:form, :save]
  prepend_before_action :access_token!, only: [:form, :save]

  before_action :load_record

  prepend_before_action :requires_activity_session!, except: [:form, :save]


  # display form to create / modify activities.
  def form
  end

  def module
    render :homepage
  end

  def homepage
    render :homepage
  end

  def save
    @story.instructions = params[:story][:instructions_as_text]
    @story.body = params[:story][:body_as_text]

    unless @story.save
      render :form
    end
  end


  private

  def story_params
    {instructions: params[:story][:instructions_as_text].to_yaml, body: params[:story][:body_as_text].to_yaml}
  end

  def load_record

    id = params[:uid] || params[:story][:id]

    @story = Story.find(id)
    @assessment = @story
  end
end
