import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { hideAfter: Number }

  connect() {
    if (this.hideAfterValue) {
      setTimeout(() => {
        this.messageTarget.remove()
      }, this.hideAfterValue)
    }
  }
}
