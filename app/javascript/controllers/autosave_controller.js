import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosave"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.timeout = null
  }

  submit() {
    // 連続で入力している間は送信を待つ（0.5秒待機）
    clearTimeout(this.timeout)
    
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
      this.showSavingIndicator()
    }, 500)
  }

  showSavingIndicator() {
    const status = document.getElementById("save_status")
    if (status) {
      status.style.opacity = "1"
      status.innerText = "SAVING..."
      
      // 1秒後に "SAVED" にして、その後消す
      setTimeout(() => {
        status.innerText = "SAVED ✓"
        setTimeout(() => {
          status.style.opacity = "0"
        }, 2000)
      }, 1000)
    }
  }
}