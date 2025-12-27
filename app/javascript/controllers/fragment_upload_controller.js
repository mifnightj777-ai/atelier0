import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "imageInput", "audioInput", "audioStatus",
    "recordButton", "recordLabel", "recordIndicator", "recordPing", "visualizer"
  ]

  connect() {
    this.isRecording = false
    this.mediaRecorder = null
    this.audioChunks = []
    this.audioCtx = null
    this.analyser = null
    this.animationFrame = null
    this.stream = null
  }

  paste(event) {
    const items = (event.clipboardData || event.originalEvent.clipboardData).items
    for (let item of items) {
      if (item.type.indexOf("image") !== -1) {
        const blob = item.getAsFile()
        const dataTransfer = new DataTransfer()
        dataTransfer.items.add(blob)
        this.imageInputTarget.files = dataTransfer.files
        this.imageInputTarget.dispatchEvent(new Event('change'))
      }
    }
  }

  async toggleRecording() {
    if (!this.isRecording) {
      try {
        this.stream = await navigator.mediaDevices.getUserMedia({ audio: true })
        
        // ブラウザが対応しているMIMEタイプを選択
        const mimeType = MediaRecorder.isTypeSupported('audio/webm') ? 'audio/webm' : 'audio/mp4'
        this.mediaRecorder = new MediaRecorder(this.stream, { mimeType })
        this.audioChunks = []

        this.mediaRecorder.ondataavailable = (e) => {
          if (e.data.size > 0) this.audioChunks.push(e.data)
        }

        // --- 波形ビジュアライザー開始 ---
        this.audioCtx = new (window.AudioContext || window.webkitAudioContext)()
        const source = this.audioCtx.createMediaStreamSource(this.stream)
        this.analyser = this.audioCtx.createAnalyser()
        this.analyser.fftSize = 32
        source.connect(this.analyser)
        this.draw()

        this.mediaRecorder.onstop = () => {
          const audioBlob = new Blob(this.audioChunks, { type: mimeType })
          const extension = mimeType.includes('webm') ? 'webm' : 'm4a'
          const audioFile = new File([audioBlob], `recording-${Date.now()}.${extension}`, { 
            type: mimeType,
            lastModified: Date.now() 
          })
          
          const dataTransfer = new DataTransfer()
          dataTransfer.items.add(audioFile)
          this.audioInputTarget.files = dataTransfer.files
          
          this.audioStatusTarget.textContent = "Voice captured. Ready to drop."
          this.audioStatusTarget.classList.add("text-indigo-600", "font-bold")
          
          // 通信の終了
          this.stream.getTracks().forEach(track => track.stop())
          if (this.audioCtx) this.audioCtx.close()
          cancelAnimationFrame(this.animationFrame)
        }

        // データの断片を1秒ごとに取得（再生時間の計算を助ける）
        this.mediaRecorder.start(1000)
        this.startUI()
      } catch (err) {
        alert("Microphone access denied.")
      }
    } else {
      if (this.mediaRecorder && this.mediaRecorder.state !== "inactive") {
        this.mediaRecorder.stop()
      }
      this.stopUI()
    }
  }

  draw() {
    const dataArray = new Uint8Array(this.analyser.frequencyBinCount)
    this.analyser.getByteFrequencyData(dataArray)
    const bars = this.visualizerTarget.children
    for (let i = 0; i < bars.length; i++) {
      const barHeight = (dataArray[i] / 255) * 16 + 4
      bars[i].style.height = `${barHeight}px`
    }
    this.animationFrame = requestAnimationFrame(() => this.draw())
  }

  startUI() {
    this.isRecording = true
    this.recordLabelTarget.textContent = "STOP"
    this.recordIndicatorTarget.classList.replace("bg-slate-300", "bg-red-500")
    this.recordPingTarget.classList.replace("opacity-0", "opacity-100")
    this.visualizerTarget.classList.remove("hidden")
  }

  stopUI() {
    this.isRecording = false
    this.recordLabelTarget.textContent = "RECORD"
    this.recordIndicatorTarget.classList.replace("bg-red-500", "bg-slate-300")
    this.recordPingTarget.classList.replace("opacity-100", "opacity-0")
    this.visualizerTarget.classList.add("hidden")
  }
}