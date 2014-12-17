window.ruleQuestionPage = function ruleQuestionPage ($page) {
  $form = $page.find('form');
  // FIXME: What on earth is this?
  $$ = $form.find.bind($form);
  $actions = $$('.chapter-test-question-actions');

  $form.find('.question-field textarea').focus();
  $form.find('.question-field textarea').bind("paste", function(e) {
    e.preventDefault();
  });

  function bypass () {
    $form.data('bypass', true);
  }

  function setStepClass (cls) {
    $actions
      .removeClass('default')
      .removeClass('first-try')
      .removeClass('second-try')
      .removeClass('correct')
      .addClass(cls);
  }

  function passed (step) {
    setStepClass('correct');
    bypass();
  }

  function failed (step) {
    // FIXME: Avoid == in JS
    setStepClass((step == 'first') ? 'first-try' : 'second-try');
    if (step == 'second') bypass();
  }

  // FIXME: Unused, remove?
  function ProcessAjaxResponse (data) {
    return queue.AddMessageToQueue(data);
  }

  function verify (data) {
    $('body').removeLoadingButton();

    if (data === null) return;

    if (data.first_grade === true || data.second_grade === null)
      $$('.js-input-step').val('second');

    if (data.first_grade  === true) return passed('first');
    if (data.second_grade === null) return failed('first');
    if (data.second_grade === true) return passed('second');
                                    return failed('second');
  }

  function checkAnswer (e) {
    if ($form.data('bypass'))
      return window.location = $actions.data('next-url');

    $.post('/verify_question', $form.serialize())
      .success(verify)
      .fail(function (err) {
        // FIXME: Avoid debugger statements in production code. Might help to lint this code.
        debugger;
      });

    e.preventDefault();
  }

  function cheat () {
    $.post('/cheat', $form.serialize())
      .success(function (data) {
        $$('.question-field :input').val(data.answer);
        $$('.chapter-test-question-actions .btn:first').click();

        setTimeout(function () {
          $$('.chapter-test-question-actions .btn:first').click();
        }, 500);
      });
  }

  window.Cheater = cheat;

  // FIXME: Why verify the answer on page load? No answer is given yet, right?
  $.get('/verify_question', $form.serialize()).success(verify);
  $page.on('click', '.btn.next', checkAnswer);
};
