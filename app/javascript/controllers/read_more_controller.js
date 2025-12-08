import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]

  connect() {
    // 画面が表示された瞬間、文字が枠より溢れているかチェック
    if (this.contentTarget.scrollHeight > this.contentTarget.clientHeight) {
      // 溢れていればボタンを表示
      this.buttonTarget.classList.remove("hidden")
    }
  }

  expand() {
    // クラスを外して全文表示にする
    this.contentTarget.classList.remove("line-clamp-3")
    // ボタンはもういらないので消す
    this.buttonTarget.classList.add("hidden")
  }
}