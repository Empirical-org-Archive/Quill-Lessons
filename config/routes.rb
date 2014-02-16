class CMS::Routes
  def draw(options = {})
    namespace :cms do
      get 'description' => 'root#description'
      get '' => 'root#index' unless options[:root] == false

      CMS::Configuration.types.each do |type|
        resources type.model_name.route_key
      end

      yield if block_given?
    end

    CMS::Configuration.pages.each do |page|
      if page.editable?
        get page.route => 'cms/pages#show', page: page.action, as: "cms_#{page.action}"
      else
        get page.route => 'cms/pages#static_page', page: page.action, as: "cms_#{page.action}"
      end
    end
  end
end

EmpiricalGrammar::Application.routes.draw do
  scope path: 'stories' do
    get 'form' => 'stories#form'
    match '' => 'stories#save', via: [:post, :put]

    get 'module' => 'stories#module'
    get 'homepage' => 'stories#homepage'
  end

  scope path: 'practice_questions' do
    get 'form'   => 'practice_questions#form'
    match ''     => 'practice_questions#save', via: [:post, :put]
    get 'module' => 'practice_questions#module'
  end

  resources :chapters, controller: 'chapter/start' do
    resources :practice, step: 'practice', controller: 'chapter/practice' do
      get ':question_index' => :show
    end

    resources :review, controller: 'practice', step: 'review', controller: 'chapter/practice' do
      get ':question_index' => :show
      get ':question_index/cheat' => :cheat
    end

    resource :story, controller: 'chapter/stories'

    get :final
  end

  get 'oauth/redirect'    => 'authentications#redirect', as: :oauth_redirect
  get 'oauth/callback'    => 'authentications#callback', as: :oauth_callback

  patch 'verify_question' => 'chapter/practice#verify'
  get   'verify_question' => 'chapter/practice#verify_status'
  patch 'cheat'           => 'chapter/practice#cheat'

  CMS::Routes.new(self).draw(root: false) do
    root 'base#root'
    resources :categories
    resources :rule_questions
    resources :rules
  end

  patch 'verify_question' => 'chapter/practice#verify'
  get   'verify_question' => 'chapter/practice#verify_status'
  patch 'cheat'           => 'chapter/practice#cheat'

  root to: 'application#root'
end
