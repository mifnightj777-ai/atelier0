import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // arrowターゲットを追加
  static targets = ["popover", "title", "content", "counter", "arrow"]

  connect() {
    this.steps = [
      { target: "nav-guidebook", title: "メインツールガイドブック", content: "この世界の歩き方やルールを確認できます。" },
      { target: "nav-focus-studio", title: "Focus Studio", content: "集中して作業に取り組むための専用空間です。" },
      { target: "nav-idea-vault", title: "Idea Vault", content: "大切なアイデアを安全に保管しておく金庫です。" },
      { target: "nav-collection", title: "コレクション", content: "集めたアイテムや記録を一覧で眺められます。" },
      { target: "nav-compare", title: "Compare Studio", content: "複数の要素を並べて比較・検討する場所です。" },
      { target: "nav-mailbox", title: "Mail box", content: "届いた手紙やシステムのお知らせを確認します。" },
      { target: "nav-dm-room", title: "DMルーム", content: "承認した特定の相手と密なやり取りを行う部屋です。" },
      { target: "nav-notification", title: "通知一覧", content: "あなたに関する最新の動きをチェックできます。" },
      { target: "nav-my-studio", title: "My Studio", content: "あなた自身のプロフィールや設定を管理します。" },
      { target: "btn-fragment-drop", title: "Fragment Drop", content: "新しい情報の断片（Fragment）をすぐに投稿できます。" }
    ]
    this.currentIndex = -1
  }

  start() {
    this.currentIndex = 0
    this.popoverTarget.classList.remove("hidden")
    setTimeout(() => {
      this.popoverTarget.classList.remove("opacity-0", "translate-y-2")
    }, 50)
    
    this.showStep()
  }

  next() {
    if (this.currentIndex < this.steps.length - 1) {
      this.currentIndex++
      this.showStep()
    } else {
      this.end()
    }
  }

  end() {
    this.popoverTarget.classList.add("opacity-0", "translate-y-2")
    setTimeout(() => {
      this.popoverTarget.classList.add("hidden")
    }, 300)
  }

  showStep() {
    const step = this.steps[this.currentIndex]
    const targetEl = document.getElementById(step.target)

    if (!targetEl) {
      console.warn(`Tutorial Error: ID '${step.target}' not found.`)
      this.end() 
      return
    }

    this.titleTarget.textContent = step.title
    this.contentTarget.textContent = step.content
    this.counterTarget.textContent = `${this.currentIndex + 1}/${this.steps.length}`

    // 座標計算
    const rect = targetEl.getBoundingClientRect()
    const popoverRect = this.popoverTarget.getBoundingClientRect()
    const targetCenter = rect.left + (rect.width / 2)

    // --- 基本設定（ヘッダーアイコン用：下に出す・矢印は上） ---
    let top = rect.bottom + 12
    // ポップオーバーの中央をターゲットの中央に合わせる
    let left = targetCenter - (popoverRect.width / 2)
    
    // 矢印の初期化（上向きに戻す）
    this.arrowTarget.classList.remove("-bottom-2", "border-b", "border-r")
    this.arrowTarget.classList.add("-top-2", "border-t", "border-l")

    // --- 右下のボタン（Fragment Drop）用：上に出す・矢印は下 ---
    if (step.target === "btn-fragment-drop") {
       top = rect.top - popoverRect.height - 12
       
       // 矢印を下向きに変更
       this.arrowTarget.classList.remove("-top-2", "border-t", "border-l")
       this.arrowTarget.classList.add("-bottom-2", "border-b", "border-r")
       
       // ボタンの少し左側に寄せる調整
       left = rect.left - 200
    }

    // --- 画面からはみ出ないように補正 ---
    const margin = 10
    // 左端チェック
    if (left < margin) {
      left = margin
    }
    // 右端チェック
    if (left + popoverRect.width > window.innerWidth - margin) {
      left = window.innerWidth - popoverRect.width - margin
    }

    // --- 矢印の位置調整（重要） ---
    // ポップオーバーの中での「ターゲットの中心」の位置を計算
    const arrowLeft = targetCenter - left - 8 // 8は矢印の幅の半分(w-4=16px)
    this.arrowTarget.style.left = `${arrowLeft}px`

    // 位置を適用
    this.popoverTarget.style.top = `${top}px`
    this.popoverTarget.style.left = `${left}px`
  }
}