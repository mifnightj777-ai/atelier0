import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "icon"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    
    if (this.isOpen) {
      this.panelTarget.classList.remove("translate-y-8", "opacity-0", "pointer-events-none")
      this.iconTarget.classList.add("rotate-12", "text-indigo-200")
    } else {
      this.panelTarget.classList.add("translate-y-8", "opacity-0", "pointer-events-none")
      this.iconTarget.classList.remove("rotate-12", "text-indigo-200")
    }
  }
}