import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop"]
  static values = { isNewUser: Boolean }

  connect() {
    // 診断ログ（コンソールで確認用）
    console.log("Install Guide: Loaded")
    console.log("Is New User?", this.isNewUserValue)

    const hasSeen = localStorage.getItem("morphe0_install_guide_seen")
    
    // ▼ ロジック変更：新規ユーザーなら、過去に見たことがあっても強制的に出す！
    // （開発中や、家族でPCを共有している場合に親切です）
    if (this.isNewUserValue) {
      console.log("Install Guide: 新規ユーザーなので表示します")
      // もし「見た」記憶があっても、新規登録直後ならリセットしてあげる
      localStorage.removeItem("morphe0_install_guide_seen")
      
      setTimeout(() => {
        this.open()
      }, 1000)
    } else {
       console.log("Install Guide: 新規ユーザーではない、または期間外なので表示しません")
    }
  }

  open() {
    this.modalTarget.classList.remove("opacity-0", "scale-95", "pointer-events-none")
    this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
  }

  close() {
    this.modalTarget.classList.add("opacity-0", "scale-95", "pointer-events-none")
    this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
    
    // 閉じた時だけ「見た」と記録する
    localStorage.setItem("morphe0_install_guide_seen", "true")
  }
}