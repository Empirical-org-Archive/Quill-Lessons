class ActivityController < ApplicationController
  before_action :admin!
  before_action :load_record, only: [:module, :form]
  prepend_before_action :access_token!

  def form
  end

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
