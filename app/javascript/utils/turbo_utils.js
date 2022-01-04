import { Turbo } from "@hotwired/turbo-rails";
// https://github.com/wakproductions/stonknotes/blob/stonknotes-009/app/javascript/utils/turbo_utils.js

var FormSubmissionState;
(function (FormSubmissionState) {
  FormSubmissionState[FormSubmissionState["initialized"] = 0] = "initialized";
  FormSubmissionState[FormSubmissionState["requesting"] = 1] = "requesting";
  FormSubmissionState[FormSubmissionState["waiting"] = 2] = "waiting";
  FormSubmissionState[FormSubmissionState["receiving"] = 3] = "receiving";
  FormSubmissionState[FormSubmissionState["stopping"] = 4] = "stopping";
  FormSubmissionState[FormSubmissionState["stopped"] = 5] = "stopped";
})(FormSubmissionState || (FormSubmissionState = {}));

export function turboReady() {
  let readyStates = [
    FormSubmissionState.stopped,
    undefined
  ];
  return readyStates.some(v => v == Turbo.navigator?.formSubmission?.state);
}
