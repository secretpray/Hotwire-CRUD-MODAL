import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animate-search"
export default class extends Controller {
  static targets = ['btnShowHide']
  
  // animate button search
  showHide(){
    var input = document.querySelector('.search-input')
    var resetSearchLink = document.querySelector('.reset-search-link')
    input.classList.toggle("active")
    input.focus()
    this.btnShowHideTarget.classList.toggle('animate')  // ? -> X
    if (resetSearchLink && input.classList.contains("active")) {
      resetSearchLink.classList.add("reset-active")
    } else if (resetSearchLink && !input.classList.contains("active")) {
      resetSearchLink.classList.remove("reset-active")
    }
  }
}
