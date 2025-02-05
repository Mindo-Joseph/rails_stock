import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.close()
    }, 3000)
  }

  disconnect() {
    // Clear the timer if the element is removed
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close() {
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateY(-10px)'

    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 150)
  }
}
