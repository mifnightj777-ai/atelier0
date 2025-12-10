import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button", "icon", "image", "status"]

  connect() {
    this.isActive = false
    this.canvas = document.createElement("canvas")
    this.ctx = this.canvas.getContext("2d", { willReadFrequently: true })
  }

  toggle() {
    if (this.isActive) {
      this.stop()
    } else {
      this.start()
    }
  }

  start() {
    if (!this.hasImageTarget) return
    this.isActive = true
    this.updateUI(true)
    
    // カーソルを十字(crosshair)にする
    // ※確実に表示させるため、SVGではなく標準の十字カーソルを優先します
    this.imageTarget.style.cursor = "crosshair"

    this.pickHandler = this.pick.bind(this)
    this.imageTarget.addEventListener("click", this.pickHandler)
  }

  stop() {
    this.isActive = false
    this.updateUI(false)
    if (this.hasImageTarget) {
      this.imageTarget.style.cursor = "default"
      this.imageTarget.removeEventListener("click", this.pickHandler)
    }
  }

  pick(event) {
    if (!this.isActive) return

    const rect = this.imageTarget.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top

    const scaleX = this.imageTarget.naturalWidth / rect.width
    const scaleY = this.imageTarget.naturalHeight / rect.height

    this.canvas.width = 1
    this.canvas.height = 1
    
    try {
      this.ctx.drawImage(
        this.imageTarget, 
        x * scaleX, y * scaleY, 1, 1, 
        0, 0, 1, 1
      )
      
      const pixel = this.ctx.getImageData(0, 0, 1, 1).data
      if (pixel[3] === 0) return // 透明部分は無視

      const hexCode = this.rgbToHex(pixel[0], pixel[1], pixel[2])
      
      // 保存
      this.saveColor(hexCode)

    } catch (e) {
      console.error("Color pick failed:", e)
      if (e.name === 'SecurityError') {
        alert("画像のセキュリティ制限により、色を抽出できません。")
        this.stop()
      }
    }
  }

  rgbToHex(r, g, b) {
    return "#" + [r, g, b].map(x => {
      const hex = x.toString(16)
      return hex.length === 1 ? "0" + hex : hex
    }).join("").toUpperCase()
  }

  updateUI(active) {
    if (active) {
      this.buttonTarget.classList.add("ring-4", "ring-pink-200", "border-pink-400", "text-pink-500", "bg-pink-50")
      this.buttonTarget.classList.remove("bg-slate-100", "text-slate-400")
      this.statusTarget.classList.remove("hidden")
      this.iconTarget.classList.add("-rotate-12", "scale-110")
    } else {
      this.buttonTarget.classList.remove("ring-4", "ring-pink-200", "border-pink-400", "text-pink-500", "bg-pink-50")
      this.buttonTarget.classList.add("bg-slate-100", "text-slate-400")
      this.statusTarget.classList.add("hidden")
      this.iconTarget.classList.remove("-rotate-12", "scale-110")
    }
  }

  async saveColor(hexCode) {
    const token = document.querySelector('meta[name="csrf-token"]').content
    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": token,
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({ hex_code: hexCode })
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (e) {
      console.error("Save failed:", e)
    }
  }
}