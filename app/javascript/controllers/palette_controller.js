import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "placeholder"]

  // チップにホバーした時に呼ばれる
  showCode(event) {
    const hex = event.currentTarget.dataset.hex
    this.displayTarget.textContent = hex
    
    // プレイスホルダー（Color Paletteという文字）を消して、コードを表示
    this.placeholderTarget.classList.add("opacity-0", "-translate-y-2")
    this.displayTarget.classList.remove("opacity-0", "translate-y-2")
  }

  // ホバーが外れた時
  reset() {
    // コードを消して、プレイスホルダーを戻す
    this.placeholderTarget.classList.remove("opacity-0", "-translate-y-2")
    this.displayTarget.classList.add("opacity-0", "translate-y-2")
  }
}