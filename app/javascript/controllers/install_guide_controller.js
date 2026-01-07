import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop"]
  static values = { isNewUser: Boolean }

  connect() {
    console.log("Install Guide: Loaded")
    
    // localStorageを確認（既読なら "true" が入っている）
    const hasSeen = localStorage.getItem("morphe0_install_guide_seen")
    
    // 「新規ユーザーである」かつ「まだ一度も見ていない」場合のみ表示
    if (this.isNewUserValue && !hasSeen) {
      console.log("Install Guide: 条件一致、表示します")
      
      setTimeout(() => {
        this.open()
      }, 1000)
    } else {
      console.log("Install Guide: 既に閲覧済み、または表示対象外です")
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
    setTimeout(() => {
    window.dispatchEvent(new CustomEvent("start-main-tutorial"))
  }, 600)
  }
  
}