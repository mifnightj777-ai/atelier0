import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "path"]
  
  connect() {
    this.timeLeft = 25 * 60 // 25分 (秒換算)
    this.timer = null
    this.isRunning = false
    this.updateDisplay()
  }

  disconnect() {
    this.stop()
  }

  toggle() {
    if (this.isRunning) {
      this.stop()
    } else {
      this.start()
    }
  }

  start() {
    if (this.isRunning) return
    
    this.isRunning = true
    this.element.classList.add("text-indigo-600") // 稼働中は色を変える
    this.element.classList.remove("text-slate-300")

    this.timer = setInterval(() => {
      if (this.timeLeft > 0) {
        this.timeLeft--
        this.updateDisplay()
      } else {
        this.complete()
      }
    }, 1000)
  }

  stop() {
    this.isRunning = false
    this.element.classList.remove("text-indigo-600")
    this.element.classList.add("text-slate-300")
    clearInterval(this.timer)
  }

  reset() {
    this.stop()
    this.timeLeft = 25 * 60
    this.updateDisplay()
  }

  complete() {
    this.stop()
    // 完了時の演出（点滅など）
    this.displayTarget.innerText = "00:00"
    this.element.classList.add("animate-bounce")
    setTimeout(() => this.element.classList.remove("animate-bounce"), 3000)
  }

  updateDisplay() {
    const minutes = Math.floor(this.timeLeft / 60)
    const seconds = this.timeLeft % 60
    // ゼロ埋めして表示 (例: 05:09)
    this.displayTarget.innerText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
  }
}