import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['content']

  // Sets the popover offset using Stimulus data map objects.
  initialize() {
    // this.contentTarget.setAttribute(
    //   'style',
    //   `transform:translate(${this.data.get('translateX')}, ${this.data.get('translateY')});`,
    // )
  }

  // Show the popover
  mouseOver() {
    // this.contentTarget.classList.remove('hidden')
    this.contentTarget.classList.add('active')
  }
  // Hide the popover
  mouseOut() {
    // this.contentTarget.classList.add('hidden')
    this.contentTarget.classList.remove('active')
  }
}
