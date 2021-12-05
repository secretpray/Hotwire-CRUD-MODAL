import { Controller } from "@hotwired/stimulus"

// Show/hide Form for reply comment
export default class extends Controller {
  static targets = [ 'form' ]

  toggle(event) {
    event.preventDefault()
    var errorsForm = document.querySelector(`#${this.formTarget.id} #error_explanation`)
    if (errorsForm) {
      errorsForm.remove()
    }
    this.formTarget.classList.toggle('hidden')
  }

  cancel(event) {
    event.preventDefault()
    var formCancel = document.getElementById(event.target.dataset.formId)
    var errors = document.querySelector(`#${event.target.dataset.formId} #error_explanation`)
    if (formCancel && errors) {
      errors.remove()
    }
    if (formCancel.id.indexOf('post_') == -1) {
      formCancel.classList.add('hidden')
    } else {
      event.target.remove()
    }
    // this.toggle(event)
  }
}
