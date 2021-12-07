import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['card_frame']

  connect() {
    if (this.hasCard_frameTarget && document.body.dataset.actionName == 'index' ) {
      this.card_frameTarget.setAttribute("style", "width: 47%;")
      // this.element.classList.add("w-2/5")
    }
    // if (document.body.dataset.actionName == 'index' ) {
    //   var btns = document.getElementsByClassName('back-button')
    //   if (btns.length > 0) {
    //     for (let btn of btns) {
    //       console.log('btn: ', btn)
    //       btn.classList.add("hidden")
    //     }
    //   }
    // }
    // btns.forEach(btn => {
    //   if (!btn.classlist.contains("hidden")) {
    //     btn.classList.add('hidden')
    //   }
    // })
  }
}
