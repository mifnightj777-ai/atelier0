import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "form"]

  connect() {
    this.messagesTarget.style.scrollBehavior = "auto"
    this.scrollToBottom()

    setTimeout(() => {
      this.messagesTarget.style.scrollBehavior = "smooth"
    }, 500)
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  resetForm() {
    this.formTarget.reset()
    setTimeout(() => {
      this.scrollToBottom()
    }, 100)
  }
}