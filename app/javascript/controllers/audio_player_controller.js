import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "icon", "progress", "timer"]

  connect() {
    this.isPlaying = false
    
    // 録音データ対策：メタデータが読み込まれた瞬間に時間を確定させる
    this.audioTarget.addEventListener('loadedmetadata', () => {
      if (this.audioTarget.duration === Infinity) {
        // durationが無限の場合、一度末尾までシークして時間を確定させる裏技
        this.audioTarget.currentTime = 1e101;
        this.audioTarget.addEventListener('timeupdate', () => {
          this.audioTarget.currentTime = 0;
          this.audioTarget.removeEventListener('timeupdate', arguments.callee);
        }, { once: true });
      }
    })
  }

  toggle() {
    this.isPlaying ? this.pause() : this.play()
  }

  play() {
    // 音が出ない問題の対策：音量を最大にセットし、ロードを確認
    this.audioTarget.volume = 1.0
    
    if (this.audioTarget.readyState === 0) {
      this.audioTarget.load()
    }

    const playPromise = this.audioTarget.play()

    if (playPromise !== undefined) {
      playPromise.then(() => {
        this.isPlaying = true
        this.updateUI("pause")
      }).catch(error => {
        console.error("Playback failed. Browser might be blocking audio:", error)
        // ユーザーインタラクションなしで再生しようとした場合のエラー
      })
    }
  }

  pause() {
    this.audioTarget.pause()
    this.isPlaying = false
    this.updateUI("play")
  }

  // バーの動きとタイマーを更新する心臓部
  updateProgress() {
    const audio = this.audioTarget
    const currentTime = audio.currentTime
    let duration = audio.duration

    // タイマー表示 (0:00)
    const mins = Math.floor(currentTime / 60)
    const secs = Math.floor(currentTime % 60).toString().padStart(2, '0')
    this.timerTarget.textContent = `${mins}:${secs}`

    // バーを動かす計算
    // duration が正常に取れない(Infinity)場合でも、再生が進んでいれば動かすためのガード
    if (isFinite(duration) && duration > 0) {
      const percent = (currentTime / duration) * 100
      this.progressTarget.style.width = `${percent}%`
    } else {
      // 録音データでdurationが取れない場合、進捗が不明なためバーは動かせませんが、
      // 少なくとも再生は継続されるようにします。
    }
  }

  seek(e) {
    const rect = e.currentTarget.getBoundingClientRect()
    const x = e.clientX - rect.left
    const percent = x / rect.width
    if (isFinite(this.audioTarget.duration)) {
      this.audioTarget.currentTime = percent * this.audioTarget.duration
    }
  }

  ended() {
    this.isPlaying = false
    this.updateUI("play")
    this.progressTarget.style.width = "0%"
    this.timerTarget.textContent = "0:00"
    this.audioTarget.currentTime = 0
  }

  updateUI(state) {
    if (state === "pause") {
      this.iconTarget.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6">
          <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 01.75.75v12a.75.75 0 01-1.5 0v-12a.75.75 0 01.75-.75zm10.5 0a.75.75 0 01.75.75v12a.75.75 0 01-1.5 0v-12a.75.75 0 01.75-.75z" clip-rule="evenodd" />
        </svg>`
    } else {
      this.iconTarget.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6">
          <path fill-rule="evenodd" d="M4.5 5.653c0-1.426 1.529-2.33 2.779-1.643l11.54 6.348c1.295.712 1.295 2.573 0 3.285L7.28 20.012c-1.25.687-2.779-.217-2.779-1.643V5.653z" clip-rule="evenodd" />
        </svg>`
    }
  }
}