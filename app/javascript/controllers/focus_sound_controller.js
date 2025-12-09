import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.currentAudio = null // 現在再生中の音を記憶する場所
  }

  // 画面から離れるとき（ページ移動時）に音を止める
  disconnect() {
    this.stopAudio()
  }

  toggle(event) {
    const button = event.currentTarget
    const soundUrl = button.dataset.soundUrl
    const isActive = button.classList.contains("text-indigo-600")

    // 1. まず全ての音と見た目をリセットする
    this.stopAudio()
    this.resetButtons()

    // 2. もし「OFFの状態」のボタンを押したなら、ONにする
    if (!isActive) {
      // 見た目をONにする
      button.classList.remove("text-slate-400", "bg-white", "border-slate-100")
      button.classList.add("text-indigo-600", "bg-indigo-50", "border-indigo-200")

      // 音を再生する
      this.playAudio(soundUrl)
    }
  }

  playAudio(url) {
    if (url) {
      this.currentAudio = new Audio(url)
      this.currentAudio.loop = true // ループ再生
      this.currentAudio.volume = 0.5 // 音量50%
      this.currentAudio.play().catch(error => {
        console.log("Audio play failed:", error)
      })
    }
  }

  stopAudio() {
    if (this.currentAudio) {
      this.currentAudio.pause()
      this.currentAudio = null
    }
  }

  resetButtons() {
    this.buttonTargets.forEach(btn => {
      btn.classList.remove("text-indigo-600", "bg-indigo-50", "border-indigo-200")
      btn.classList.add("text-slate-400", "bg-white", "border-slate-100")
    })
  }
}