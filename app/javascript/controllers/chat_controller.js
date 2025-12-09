import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "form"]

  connect() {
    this.scrollToBottom()
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