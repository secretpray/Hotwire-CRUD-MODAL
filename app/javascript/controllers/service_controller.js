import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="service"
export default class extends Controller {
  connect() {
  }

  hideHistory() {
    const h = document.querySelector('.user_search_history')
    if (h.classList.contains('active')) {
      h.classList.remove('active')
    }
  }
}
