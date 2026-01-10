import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosave"
export default class extends Controller {
  static targets = ["status"]

  connect() {
    this.timeout = null
  }

  // 文字入力のたびに呼ばれる
  submit() {
    clearTimeout(this.timeout)
    
    // 0.5秒後に保存処理を実行
    this.timeout = setTimeout(() => {
      this.save()
    }, 500)
  }

  // データを裏側でこっそり送る処理（Fetch）
  async save() {
    this.showSaving()

    const form = this.element
    const formData = new FormData(form)
    
    // Railsのセキュリティトークンを取得（これがないとエラーになる）
    const token = document.querySelector('meta[name="csrf-token"]').content

    try {
      const response = await fetch(form.action, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": token,
          "Accept": "text/vnd.turbo-stream.html" // サーバーに「Turboだよ」と伝える
        },
        body: formData
      })

      if (response.ok) {
        this.showSaved()
      } else {
        this.showError()
      }
    } catch (error) {
      console.error(error)
      this.showError()
    }
  }

  // --- 表示の制御 ---

  showSaving() {
    if (this.hasStatusTarget) {
      this.statusTarget.style.opacity = "1"
      this.statusTarget.style.color = "#6366f1" // インディゴ
      this.statusTarget.innerText = "SAVING..."
    }
  }

  showSaved() {
    if (this.hasStatusTarget) {
      this.statusTarget.style.color = "#10b981" // 緑
      this.statusTarget.innerText = "SAVED ✓"
      
      // 2秒後に消す
      setTimeout(() => {
        this.statusTarget.style.opacity = "0"
      }, 2000)
    }
  }

  showError() {
    if (this.hasStatusTarget) {
      this.statusTarget.style.color = "#ef4444" // 赤
      this.statusTarget.innerText = "ERROR!"
    }
  }
}