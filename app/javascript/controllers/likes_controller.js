import { Controller } from "@hotwired/stimulus"
import { FetchRequest, get } from '@rails/request.js'

export default class extends Controller {
    static targets = ['button']
    static values = { url: String }

  connect() {
    this.getData()
  }

  async getData() {
    const request = new FetchRequest("get", this.urlValue, {responseKind: "turbo-stream"})
    const response = await request.perform()
    if (response.ok) {
      // console.log('Server response OK!')
    }

  }
}
