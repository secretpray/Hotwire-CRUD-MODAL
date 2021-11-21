import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    console.log('Connect to Flash!')
    setTimeout(() => this.dismiss(), 5000)
  }

  dismiss() {
    this.element.remove()
  }
}
