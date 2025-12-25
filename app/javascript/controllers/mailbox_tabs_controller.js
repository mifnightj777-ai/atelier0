import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background"]

  connect() {
    // ページ読み込み時に、現在アクティブなタブに枠を合わせる
    const activeLink = this.element.querySelector('.text-slate-900')
    if (activeLink) {
      this.moveBackground(activeLink)
    }
  }

  switch(event) {
    // クリックされた時
    this.moveBackground(event.currentTarget)
    
    // 文字色の切り替え
    const links = this.element.querySelectorAll('a')
    links.forEach(link => {
      link.classList.remove('text-slate-900')
      link.classList.add('text-slate-400')
    })
    event.currentTarget.classList.add('text-slate-900')
    event.currentTarget.classList.remove('text-slate-400')
  }

  moveBackground(element) {
    // 枠の幅と位置を、ターゲットの要素にミリ単位で合わせる
    this.backgroundTarget.style.width = `${element.offsetWidth}px`
    this.backgroundTarget.style.left = `${element.offsetLeft}px`
  }
}