import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]
  static values = {
    productId: Number,
    threshold: Number
  }

  connect() {
    this.updateStockStatus()
  }

  updateQuantity(event) {
    const newQuantity = parseInt(event.target.value)
    this.quantityTarget.textContent = newQuantity

    // Update via Turbo Stream
    this.element.requestSubmit()
  }

  updateStockStatus() {
    const quantity = parseInt(this.quantityTarget.textContent)
    const status = quantity <= this.thresholdValue ? "low-stock" : "in-stock"
    this.element.setAttribute("data-status", status)
  }
}
