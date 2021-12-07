import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['back_button', 'hover']

  connect() {
    if (document.body.dataset.actionName != 'index' ) {
      // disable double click
      delete this.element.dataset.action
      // add button back to show page
      this.back_buttonTarget.classList.remove('hidden')
      // remove hover feature on show page
      this.hoverTarget.classList.remove('hover:scale-95', 'group', 'hover:bg-gray-700', 'cursor-pointer')
    }

  }
}
