import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["paper", "saveButton", "toast"]

  connect() {
    this.applySavedSettings()
    
    // ページ読み込み時にトースト（保存成功メッセージ）があれば表示する
    if (this.hasToastTarget) {
      this.showToast()
    }

    setTimeout(() => {
      if (window.lucide) { window.lucide.createIcons() }
    }, 50)

    this.mouseHandler = this.handleMouseMove.bind(this)
    document.addEventListener('mousemove', this.mouseHandler)
  }

  // --- トースト通知の演出 ---
  showToast() {
    // フワッと浮かび上がるアニメーション
    this.toastTarget.classList.remove("opacity-0", "translate-y-4", "pointer-events-none")
    this.toastTarget.classList.add("opacity-100", "translate-y-0")

    // 3秒後に自動的に消える
    setTimeout(() => {
      this.toastTarget.classList.replace("opacity-100", "opacity-0")
      this.toastTarget.classList.add("translate-y-4")
    }, 3000)
  }

  // --- SAVEボタンのクリック時フィードバック ---
  saveFeedback() {
    this.saveButtonTarget.innerHTML = `
      <svg class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      <span class="ml-2">SAVING...</span>
    `
    // クリック後はボタンの色を固定
    this.saveButtonTarget.classList.add('bg-indigo-600')
  }

  // --- 以降、設定反映ロジック (変更なし) ---
  applySavedSettings() {
    const paper = localStorage.getItem('atelier0_paper') || 'p-white'
    const font = localStorage.getItem('atelier0_font') || 'f-sans'
    const size = localStorage.getItem('atelier0_size') || 'ts-m'
    const immerse = localStorage.getItem('atelier0_immerse') || 'none'

    if (this.hasPaperTarget) {
      this.paperTarget.classList.remove('p-white', 'p-beige', 'p-black', 'f-sans', 'f-serif', 'f-round', 'ts-s', 'ts-m', 'ts-l')
      this.paperTarget.classList.add(paper, font, size)
    }

    const body = document.getElementById('focus-body')
    if (body) {
      body.classList.remove('mode-soft', 'mode-hard')
      if (immerse !== 'none') body.classList.add(`mode-${immerse}`)
    }
    this.refreshActiveStyles(paper, font, size, immerse)
  }

  refreshActiveStyles(paper, font, size, immerse) {
    document.querySelectorAll('.design-btn-font, .design-btn-size, .mode-btn').forEach(b => b.classList.remove('active-choice'))
    document.querySelectorAll('[id^="btn-p-"]').forEach(b => b.classList.remove('active-color'))
    document.getElementById('btn-' + paper)?.classList.add('active-color')
    document.getElementById('btn-' + font)?.classList.add('active-choice')
    document.getElementById('btn-' + size)?.classList.add('active-choice')
    document.getElementById('btn-mode-' + immerse)?.classList.add('active-choice')
  }

  setPaper(e) { localStorage.setItem('atelier0_paper', e.currentTarget.dataset.value); this.applySavedSettings(); }
  setFont(e) { localStorage.setItem('atelier0_font', e.currentTarget.dataset.value); this.applySavedSettings(); }
  setSize(e) { localStorage.setItem('atelier0_size', e.currentTarget.dataset.value); this.applySavedSettings(); }
  setMode(e) { localStorage.setItem('atelier0_immerse', e.currentTarget.dataset.value); this.applySavedSettings(); }
}