import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['frame', 'container', 'showButton']

  // click on background
  closeBackground(event) {
    if (event.target === this.containerTarget) {
      this.close(event)
    }
  }
  // ESC
  closeWithKeyboard(event) {
    if (event.keyCode === 27 && !this.containerTarget.classList.contains(this.toggleClass)) {
      this.close(event)
    }
  }

  close(event) {
    event && event.preventDefault()
    this.containerTarget.remove()
    this.frameTarget.src = ''
  }

  // Show post with doubleclick
  showPost(event) {
    var buttonShow = document.getElementById(`btn_show_${+event.currentTarget.dataset.id}`)
    if (buttonShow && document.body.dataset.actionName == 'index') {
      buttonShow.click()
    }
  }
}
