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
    // event.stopPropagation()
    this.containerTarget.remove()
    this.frameTarget.src = ''
  }

  // Show post with doubleclick
  showPost(event) {
    if (this.hasShowButtonTarget) {
      this.showButtonTarget.click()
    }
  }
}
