import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    if (this.isOpen) {
      this.panelTarget.classList.remove("translate-x-full")
    } else {
      this.panelTarget.classList.add("translate-x-full")
    }
  }
}