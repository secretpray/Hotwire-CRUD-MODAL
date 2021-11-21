import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['frame', 'container']

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
    // event && event.preventDefault()
    // event.preventDefault()
    // event.stopPropagation()
    // console.log('this.containerTarget: ', this.containerTarget)
    this.containerTarget.remove()
    // console.log('this.frameTarget.src: ', this.frameTarget.src )
    this.frameTarget.src = ''
  }
}
