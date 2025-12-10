import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  disconnect() {
    this.hideTooltip()
  }

  copy() {
    navigator.clipboard.writeText(this.textValue).then(() => {
      this.showCopiedFeedback()
    })
  }

  // ▼ マウスオーバーで吹き出しを表示（チップの上側に固定）
  showTooltip(event) {
    if (this.tooltip) this.tooltip.remove()

    this.tooltip = document.createElement("div")
    // 画面最前面(z-[9999])に表示
    this.tooltip.className = "fixed z-[9999] pointer-events-none transition-opacity duration-200 opacity-0"
    
    // 吹き出しのしっぽ（三角）を下側（-bottom-1）に配置して、上にあるように見せる
    this.tooltip.innerHTML = `
      <div class="bg-indigo-600 text-white text-[10px] font-['Poppins'] font-bold py-1.5 px-3 rounded-full shadow-xl flex flex-col items-center relative transform -translate-x-1/2">
        <span class="tracking-widest whitespace-nowrap relative z-10">${this.textValue}</span>
        <div class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-indigo-600 rotate-45"></div>
      </div>
    `
    document.body.appendChild(this.tooltip)

    const rect = this.element.getBoundingClientRect()
    
    // ▼ 位置計算: チップの頭頂部 (rect.top) から 35px 上に配置
    this.tooltip.style.left = `${rect.left + rect.width / 2}px`
    this.tooltip.style.top = `${rect.top - 35}px`

    requestAnimationFrame(() => {
      this.tooltip.classList.remove("opacity-0")
    })
  }

  hideTooltip() {
    if (this.tooltip) {
      this.tooltip.remove()
      this.tooltip = null
    }
  }

  showCopiedFeedback() {
    this.element.classList.add("ring-2", "ring-indigo-400", "scale-110")
    
    if (this.tooltip) {
      const span = this.tooltip.querySelector("span")
      const originalText = span.innerText
      span.innerText = "Copied!"
      
      setTimeout(() => {
        if (this.tooltip) span.innerText = originalText
      }, 1000)
    }

    setTimeout(() => {
      this.element.classList.remove("ring-2", "ring-indigo-400", "scale-110")
    }, 200)
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}