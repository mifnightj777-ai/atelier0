import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["book"]

  connect() {
    // 初期状態などあれば
  }

  activate(event) {
    // 全ての本から active クラスを外す
    this.bookTargets.forEach(el => {
      el.classList.remove("translate-y-4", "shadow-xl", "z-10", "bg-opacity-100")
      el.classList.add("hover:-translate-y-2") // ホバー効果を戻す
      
      // 非アクティブな本は少し薄くする演出（お好みで）
      el.querySelector('.book-spine').classList.remove("ring-2", "ring-indigo-400")
    })

    // クリックされた本（イベント発生元に近い data-bookshelf-target="book"）を取得
    const activeBook = event.currentTarget

    // アクティブ化（下に引き出す + 強調）
    activeBook.classList.remove("hover:-translate-y-2")
    activeBook.classList.add("translate-y-4", "shadow-xl", "z-10")
    activeBook.querySelector('.book-spine').classList.add("ring-2", "ring-indigo-400")
  }
  
  reset() {
    // リセット用（必要なら）
  }
}