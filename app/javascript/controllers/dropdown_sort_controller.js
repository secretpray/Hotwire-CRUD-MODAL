import { Controller } from "@hotwired/stimulus"
import {enter, leave} from 'el-transition'

export default class extends Controller {
  static targets = ["menu", "button", "submit"]

  toggleMenu() {
    if(this.menuTarget.classList.contains('hidden')) {
      enter(this.menuTarget)
    } else {
      leave(this.menuTarget)
    }
  }

  closeWithKeyboard(event) {
    switch (event.keyCode) {
      case 27: // ESC
      leave(this.menuTarget)
    }
  }

  clickSort() {
    if(this.hasSubmitTarget && !this.menuTarget.classList.contains('hidden')) {
      this.submitTarget.click()
      leave(this.menuTarget)
    }
  }

  hideMenu(event) {
    const buttonClicked = this.buttonTarget.contains(event.target)
    if (!this.buttonTarget.contains(event.target) && !this.menuTarget.contains(event.target) ) {
      leave(this.menuTarget)
    }
  }
}
