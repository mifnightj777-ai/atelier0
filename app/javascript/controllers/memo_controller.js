import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // ターゲットを確実に定義
  static targets = ["panel", "icon", "inputContainer", "colorField"]

  connect() {
    this.isOpen = false
    console.log("Memo controller connected!") // これがコンソールに出れば接続成功
  }

  toggle() {
    this.isOpen = !this.isOpen
    console.log("Memo toggle state:", this.isOpen) // クリックしてこれが出ればJSは動いています

    if (this.isOpen) {
      // パネルを表示（透明度を上げ、位置を戻し、クリック可能にする）
      this.panelTarget.classList.remove("translate-y-8", "opacity-0", "pointer-events-none")
      this.panelTarget.classList.add("translate-y-0", "opacity-100", "pointer-events-auto")
      // アイコンの色と角度を変える（わかりやすくindigo-500に変更）
      this.iconTarget.classList.add("rotate-12", "text-indigo-500")
    } else {
      // パネルを隠す
      this.panelTarget.classList.add("translate-y-8", "opacity-0", "pointer-events-none")
      this.panelTarget.classList.remove("translate-y-0", "opacity-100", "pointer-events-auto")
      this.iconTarget.classList.remove("rotate-12", "text-indigo-500")
    }
  }

  // 色変更のロジック
  changeColor(event) {
    const colorClass = event.currentTarget.dataset.color
    console.log("Changing color to:", colorClass)

    if (this.hasInputContainerTarget) {
      this.inputContainerTarget.className = `rounded-2xl p-5 shadow-inner transition-colors ${colorClass}`
    }
    if (this.hasColorFieldTarget) {
      this.colorFieldTarget.value = colorClass
    }
  }
}