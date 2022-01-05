import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ['btnShowHide']

  showHide() {
    const input = document.querySelector('.search-input')
    const resetSearchLink = document.querySelector('.reset-search-link')
    const userHistory = document.querySelector('.user_search_history')

    this.btnShowHideTarget.classList.toggle('animate')  // ? -> X
    input.classList.toggle("active")
    input.focus()
    userHistory.classList.toggle("active")

    // if (input.classList.contains("active")) {
    //   userHistory.classList.add("active")
    // } else {
    //   userHistory.classList.remove("active")
    // }

    if (resetSearchLink && input.classList.contains("active")) {
      resetSearchLink.classList.add("reset-active")
    } else if (resetSearchLink && !input.classList.contains("active")) {
      resetSearchLink.classList.remove("reset-active")
    }
  }
}
