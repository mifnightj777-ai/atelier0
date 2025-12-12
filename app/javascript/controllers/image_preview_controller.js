import { Controller } from "@hotwired/stimulus"

// 画像プレビュー機能
export default class extends Controller {
  static targets = ["input", "output", "placeholder"]

  // ファイルが選択されたら実行される
  preview() {
    const file = this.inputTarget.files[0]
    if (file) {
      // ファイルを読み込む
      const reader = new FileReader()
      reader.onload = (e) => {
        // 読み込んだ画像データを<img>タグのsrcにセット
        this.outputTarget.src = e.target.result
        this.outputTarget.classList.remove("hidden")
        // プレースホルダー（「？」の表示など）があれば隠す
        if (this.hasPlaceholderTarget) {
          this.placeholderTarget.classList.add("hidden")
        }
      }
      reader.readAsDataURL(file)
    }
  }
}