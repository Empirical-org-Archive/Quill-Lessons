EmpiricalGrammar::Application.routes.draw do
  scope path: 'stories' do
    get 'form' => 'stories#form'
    match '' => 'stories#save', via: [:post, :put]

    get 'module' => 'stories#module'
    get 'homepage' => 'stories#homepage'
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
    get :start
    get :resume
    get :retry
-    patch 'verify_question' => 'chapter/practice#verify'
-    get   'verify_question' => 'chapter/practice#verify_status'
-    patch 'cheat'           => 'chapter/practice#cheat'
  end
end
