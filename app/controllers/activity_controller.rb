class ActivityController < ApplicationController
  before_action :admin!,                only: [:form, :save]
  before_action :load_record,           only: [:form, :module]
  prepend_before_action :access_token!, only: [:form, :save]

  # handle display of a Compass activity. Specifics are implemented in
  # subclasses of ActivityController.
  def module
  end

  # display form to create / modify activities.
  def form
  end

  # save data from form.
  def save
    @record = model.new(params[subject].merge(access_token: session[:access_token]))

    unless @record.save
      render :form
    end
  end

protected

  def load_record
    @record = model.new(id: params[:uid], access_token: session[:access_token])
    instance_variable_set(:"@#{subject}", @record)
  end
end
