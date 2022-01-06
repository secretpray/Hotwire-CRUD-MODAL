import { Controller } from "@hotwired/stimulus" // bin/rails g stimulus search
import debounce from 'lodash/debounce' // yarn add lodash or import debounce from "https://cdn.skypack.dev/lodash.debounce"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [ 'searchInput' ]

  connect() {
    //this.search_with_debounce = debounce(this.search_with_debounce.bind(this), 500) // bind debounce to search_debonce
    this.search_with_debounce = debounce(this.search_with_debounce, 500)
  }

  // Hide default browser Errors validations input Search message
  hideValidationMessage(event) {
    event.stopPropagation()
    event.preventDefault()
  }

  search_with_debounce = () => {
    if (this.searchInputTarget.value.length > 1) {
      this.hideHistory()
      this.element.requestSubmit()
    }
  }

  hideHistory() {
    const hist = document.querySelector('.user_search_history')

    if (hist.classList.contains('active')) {
      hist.classList.remove('active')
    }
  }
}
