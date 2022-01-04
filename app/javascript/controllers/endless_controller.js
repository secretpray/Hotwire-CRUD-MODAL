import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

let count = null,             // timer duartion
    running = true,           // loader status
    mOld = null,              // old timer value
    mNew = null,              // new timer value
    options = {               // options for Observer
                root: null,
                rootMargins: "0px",
                threshold: 0.7 // Target overlap percentage (1.0 - 100%)
    }

const intersections = new Map() // map set for Observer

export default class extends Controller {

  static targets = [
                     "footer",
                     "current",
                     "next",
                     "pagination",
                     "pagination_prev",
                     "loader",
                     "seconds",
                     "milliseconds"
                   ]
  static values = {
                    request: Boolean
                   }

  connect() {
    if (document.body.dataset.actionName == 'index') {
      this.createObserver()
    }
  }

  createObserver() {
    const observer = new IntersectionObserver(this.callback, options)

    if (this.hasFooterTarget) { observer.observe(this.footerTarget) }
  }


  draw = () => {
    if (count > 0 && running) {
      requestAnimationFrame(() => {
        this.draw()
      })
      mNew = new Date().getTime();
      count = count - mNew + mOld;
      count = count >= 0 ? count : 0;
      mOld = mNew;
      this.secondsTarget.innerText = Math.floor(count / 1000);
      this.millisecondsTarget.innerText = count % 1000;
    } else {
      this.secondsTarget.innerText = 0
      this.millisecondsTarget.innerText = 0
    }
  }

  // little usability hack: add page 1 link if all page added and prevPage.href = null
  firstLinkAddIfNeeded = () => {
    let service = this.nextTarget.dataset['service']
    let result = Number(this.currentTarget.dataset['totalpage']) - Number(service)
    if (result < 2 && !this.hasPagination_prevTarget) {
      const firstUrl = this.currentTarget.dataset['prevpageLinkCurrent']
      const prevElement = document.getElementById('pagination-prev')
      prevElement.removeAttribute('disabled')
      prevElement.href = firstUrl
      prevElement.innerText = '1'
      prevElement.classList.remove('hover:opacity-25', 'cursor-default')
      prevElement.classList.add('hover:opacity-100')
    }
  }

  _loadMore = async () => {
  // _loadMore = () => {
    if (!this.hasPaginationTarget || this.requestValue) {
      return
    }

    this.requestValue = true
    const prevPageValue = this.currentTarget.dataset['prevpage']
    const endlessUrl = new URL(this.paginationTarget.href)
    // endlessUrl.searchParams.set("endless", prevPageValue)
    endlessUrl.searchParams.append("endless", prevPageValue)
    // async fetch
    await get(endlessUrl.toString(), {responseKind: 'turbo-stream'})
    this.firstLinkAddIfNeeded()
    this.requestValue = false
  }

  intersectionChanged = (entry) => {
    if (entry.isIntersecting && this.hasPaginationTarget) {
      this.loaderTarget.classList.add("show")
      mOld = new Date().getTime();
      running = true      // timer start
      // clearInterval(intersections.get(entry.target))
      count = 2500        // set timer duration (2500 -> 2.5 sec)
      this.draw()
      intersections.set(entry.target, setInterval(() => {
        this.loaderTarget.classList.remove("show");
        running = false   // timer stop
        // console.log('Infinity scroll fired!')
        this._loadMore()
      }, 2500))
    } else if (!entry.isIntersecting && intersections.get(entry.target) != null) {
      this.loaderTarget.classList.remove("show");
      running = false     // timer stop
      // console.log('Timeout infinity scroll disabled!')
      clearInterval(intersections.get(entry.target))
    }
  }

  callback = (entries, observer) => {
    entries.forEach(entry => this.intersectionChanged(entry))
  }
}
