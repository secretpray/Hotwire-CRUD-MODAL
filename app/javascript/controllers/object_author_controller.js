import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    authorId: String
  }

  connect() {
    if (this.currentUserId === this.authorId) {
      this.element.classList.remove("hidden")
    }
  }

  get authorId() {
    return this.authorIdValue
  }

  get currentUserId() {
    return document.querySelector("[name='current-user-id']").content
  }
}
