import { Controller } from "@hotwired/stimulus"
import { turboReady } from "../utils/turbo_utils"

// Connects to data-controller="endless"
export default class extends Controller {
  static targets = [ "footer", "pagination" ]
  static values = {
    prevpage: String,
    request: Boolean,
  }

  connect() {
    this.createObserver()
  }

  start(event){
    console.log('turbo:before-visit')
    console.log('event.detail.url: ', event.detail.url)
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
      if (entry.isIntersecting && document.body.dataset.actionName == 'index' && !this.requestValue) {
        // console.log('this.requestValue (fired load more): ', this.requestValue)
        this.loadMore()
      }
    })
  }

  loadMore() {
    if(!this.hasPaginationTarget || !this.paginationTarget.href) {
      return
    }

    const href = this.paginationTarget.href
    const prevPage = this.paginationTarget.dataset['endlessPrevpageValue']
    const endlessUrl = new URL(this.paginationTarget.href)
    endlessUrl.searchParams.append("endless", prevPage)
    this.requestValue = true;
    fetch(endlessUrl, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
    .then(r => r.text())
    .then(html => Turbo.renderStreamMessage(html))
    // .then(_ => history.replaceState(history.state, "", href))
    this.requestValue = false;
  }
}
