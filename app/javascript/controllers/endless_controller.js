import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js";
// import { turboReady } from "../utils/turbo_utils" // wait formSubmission (not needed now)

export default class extends Controller {
  static targets = [ "footer", "pagination" ]
  static values = {
    prevpage: String,
    request: Boolean,
  }

  connect() {
    this.createObserver()
  }

  createObserver() {
    const observer = new IntersectionObserver(entries => this.handleIntersect(entries),
      {
        threshold: [0, 1.0],
      }
    )
    observer.observe(this.footerTarget)
  }

  handleIntersect(entries) {
    entries.forEach(entry => {
      // check: view footer in index page
      if (entry.isIntersecting && document.body.dataset.actionName == 'index') {
        this._loadMore()
      }
    })
  }

  async _loadMore() {
    // return if busy by prev request or !has next page link
    if (this.requestValue || !this.hasPaginationTarget) {
      return
    }

    const prevPage = this.paginationTarget.dataset['endlessPrevpageValue']
    const endlessUrl = new URL(this.paginationTarget.href)
    // endlessUrl.searchParams.set("endless", prevPage)
    endlessUrl.searchParams.append("endless", prevPage)
    // busy
    this.requestValue = true
    // async fetch
    await get(endlessUrl.toString(), {responseKind: 'turbo-stream'});
    // not busy
    this.requestValue = false;
  }
}
