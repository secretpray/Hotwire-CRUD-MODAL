import { Controller } from "@hotwired/stimulus" // bin/rails g stimulus search
import debounce from 'lodash/debounce' // yarn add lodash

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['searchInput']

  connect() {
    this.search_with_debounce = debounce(this.search_with_debounce, 500).bind(this) // bind debounce to search_debonce
  }
  search_with_debounce() {
    // console.log('this.hasSearchInputTarget', this.hasSearchInputTarget)
    // console.log('Fired debonce search! (event.target)', event.target) // input -> event.target
    // console.log('Fired debonce search! (this.element)', this.element) // form -> this.element
    // fired if input > 2 letters
    if (this.searchInputTarget.value.length > 1) {
      // console.log('event.target.value.lenght)', event.target.value.lenght)
      // console.log('this.searchInputTarget.value.length)', this.searchInputTarget.value.length)
      this.element.requestSubmit()
    }
  }
}