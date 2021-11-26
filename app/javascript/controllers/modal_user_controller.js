import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // form_frame -> for SRC, user_modal_form -> close modal, container_form - close by click background
  static targets = ['form_frame', 'user_modal_form', 'container_form']

  // close modal by click on background
  closeFromBackground(event) {
    if (event.target === this.container_formTarget) {
      this.close(event)
    }
  }
  // close modal by press ESC
  closeWithKeyboard(event) {
    if (event.keyCode === 27 && !this.container_formTarget.classList.contains(this.toggleClass)) {
      this.close(event)
    }
  }

  close(event) {
    event && event.preventDefault()
    // event.stopPropagation()
    this.user_modal_formTarget.remove()
    this.form_frameTarget.src = ''
  }
}
