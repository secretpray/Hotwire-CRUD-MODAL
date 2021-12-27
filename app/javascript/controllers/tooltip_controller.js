import { Controller } from "@hotwired/stimulus"
import { debounce } from './modules/debouncer';

export default class extends Controller {
  connect() {
    document.getElementById('post-tooltip').classList.remove('active')
    document.getElementById('header-tooltip').classList.remove('active')
  }

  hoverInPostFired = debounce(function() {
    document.getElementById('post-tooltip').classList.toggle('active')
  }, 700)

  hoverIHeaderFired = debounce(function() {
    document.getElementById('header-tooltip').classList.toggle('active')
  }, 700)

  hoverInPost() {
    this.hoverInPostFired()
  }

  hoverInHeader() {
    this.hoverIHeaderFired()
  }
}
