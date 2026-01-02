import { Controller } from "@hotwired/stimulus"

// ▼▼▼ SignaturePad クラス ▼▼▼
class SignaturePad {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.options = options;
    this._ctx = canvas.getContext("2d");
    this._isDown = false;
    this._points = [];
    
    this.lineWidth = options.minWidth || 3;
    this.penColor = options.penColor || "black";
    this.backgroundColor = options.backgroundColor || "rgba(0,0,0,0)";
    
    this._handleDown = this._handleDown.bind(this);
    this._handleMove = this._handleMove.bind(this);
    this._handleUp = this._handleUp.bind(this);
    
    this.on();
  }

  setLineWidth(width) {
    this.lineWidth = width;
  }

  fromDataURL(dataUrl) {
    return new Promise((resolve) => {
      const image = new Image();
      image.onload = () => {
        this._ctx.drawImage(image, 0, 0, this.canvas.width, this.canvas.height);
        resolve();
      };
      image.src = dataUrl;
    });
  }

  clear() {
    this._ctx.fillStyle = this.backgroundColor;
    this._ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this._ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    this._points = [];
  }

  toDataURL(type = "image/png", quality) {
    return this.canvas.toDataURL(type, quality);
  }

  isEmpty() {
    return this._points.length === 0;
  }

  activePen() {
    this._ctx.globalCompositeOperation = 'source-over';
  }

  activeEraser() {
    this._ctx.globalCompositeOperation = 'destination-out';
  }

  on() {
    this.canvas.style.touchAction = "none";
    this.canvas.addEventListener("mousedown", this._handleDown);
    this.canvas.addEventListener("mousemove", this._handleMove);
    document.addEventListener("mouseup", this._handleUp);
    
    this.canvas.addEventListener("touchstart", (e) => {
      e.preventDefault();
      if (e.targetTouches.length === 1) {
        this._handleDown(this._getTouchPoint(e.changedTouches[0]));
      }
    }, { passive: false });

    this.canvas.addEventListener("touchmove", (e) => {
      e.preventDefault();
      this._handleMove(this._getTouchPoint(e.targetTouches[0]));
    }, { passive: false });

    this.canvas.addEventListener("touchend", (e) => {
      this._handleUp();
    });
  }

  _getTouchPoint(touch) {
    return { clientX: touch.clientX, clientY: touch.clientY };
  }

  _handleDown(event) {
    this._isDown = true;
    this._points = [];
    const point = this._createPoint(event);
    this._points.push(point);
    
    this._ctx.beginPath();
    this._ctx.moveTo(point.x, point.y);
    this._ctx.lineTo(point.x, point.y);
    this._ctx.lineWidth = this.lineWidth;
    this._ctx.lineCap = "round";
    this._ctx.lineJoin = "round";
    this._ctx.strokeStyle = this.penColor;
    this._ctx.stroke();
  }

  _handleMove(event) {
    if (!this._isDown) return;
    const point = this._createPoint(event);
    this._points.push(point);
    this._ctx.lineWidth = this.lineWidth;
    this._ctx.lineCap = "round";
    this._ctx.lineJoin = "round";
    this._ctx.strokeStyle = this.penColor;
    const prevPoint = this._points[this._points.length - 2];
    this._ctx.beginPath();
    this._ctx.moveTo(prevPoint.x, prevPoint.y);
    this._ctx.lineTo(point.x, point.y);
    this._ctx.stroke();
  }

  _handleUp() {
    this._isDown = false;
  }

  _createPoint(event) {
    const rect = this.canvas.getBoundingClientRect();
    return {
      x: event.clientX - rect.left,
      y: event.clientY - rect.top
    };
  }
}

// ▼▼▼ コントローラー本体 ▼▼▼
export default class extends Controller {
  static targets = ["canvas", "input", "preview", "modal", "saveBtn", "clearBtn", "closeBtn", "penBtn", "eraserBtn", "sizeBtn", "form"]

  connect() {
    // ★重要: 安全装置を追加！
    // フォーム（input）が無い画面（アイデア新規作成画面など）では、何もしないで終了します。
    if (!this.hasInputTarget) return;

    this.modalEl = this.modalTarget
    this.canvasEl = this.canvasTarget
    this.inputEl = this.inputTarget
    this.previewEl = this.previewTarget
    this.formEl = this.formTarget
    
    this.saveBtnEl = this.saveBtnTarget
    this.clearBtnEl = this.clearBtnTarget
    this.closeBtnEl = this.closeBtnTarget
    this.penBtnEl = this.penBtnTarget
    this.eraserBtnEl = this.eraserBtnTarget
    this.sizeBtnEls = this.sizeBtnTargets

    this.penWidth = 6
    this.eraserWidth = 12 
    this.currentMode = 'pen'
    
    this.defaultAction = this.formEl.action

    this.pad = new SignaturePad(this.canvasEl, {
      backgroundColor: 'rgba(255, 255, 255, 0)',
      penColor: 'rgb(51, 65, 85)',
      minWidth: this.penWidth
    })

    this.bindEvents()
    document.body.appendChild(this.modalEl)
    this.resizeCanvas()
    window.addEventListener("resize", () => this.resizeCanvas())
    
    this.formEl.addEventListener("turbo:submit-end", () => {
      this.resetFormState()
    })
    
    setTimeout(() => { this.updateUI() }, 10)
  }

  bindEvents() {
    this.saveBtnEl.addEventListener("click", (e) => this.applyDrawing(e))
    this.clearBtnEl.addEventListener("click", (e) => this.clear(e))
    this.closeBtnEl.addEventListener("click", (e) => this.cancel(e))
    this.penBtnEl.addEventListener("click", (e) => this.switchToPen(e))
    this.eraserBtnEl.addEventListener("click", (e) => this.switchToEraser(e))
    this.sizeBtnEls.forEach(btn => {
      btn.addEventListener("click", (e) => {
        const size = parseInt(e.currentTarget.dataset.size)
        this.changeSize(size)
      })
    })
  }

  disconnect() {
    if (this.modalEl) this.modalEl.remove()
  }

  startNew(e) {
    if(e) e.preventDefault()
    this.resetFormState()
    this.openModal()
  }

  edit(e) {
    e.preventDefault()
    const button = e.currentTarget
    const img = button.querySelector("img")
    const imageUrl = img ? img.src : null
    const updateUrl = e.params.url

    if (imageUrl && updateUrl) {
      this.formEl.action = updateUrl
      this._setMethod("patch")
      this.openModal()
      this.pad.fromDataURL(imageUrl)
    }
  }

  openModal() {
    this.modalEl.classList.remove("hidden")
    this.resizeCanvas() 
    document.body.style.overflow = "hidden"
    this.switchToPen() 
  }

  applyDrawing(e) {
    if(e) e.preventDefault()
    const data = this.pad.toDataURL()
    this.inputEl.value = data
    this.previewEl.src = data
    this.previewEl.classList.remove("hidden")
    this.hideModal()
    this.formEl.requestSubmit()
  }

  cancel(e) {
    if(e) e.preventDefault()
    this.hideModal()
    setTimeout(() => {
      this.resetFormState()
    }, 300)
  }

  hideModal() {
    this.modalEl.classList.add("hidden")
    document.body.style.overflow = ""
  }

  resetFormState() {
    this.formEl.action = this.defaultAction
    this._setMethod("post")
    this.pad.clear()
    this.inputEl.value = ""
    this.previewEl.classList.add("hidden")
    this.previewEl.src = ""
  }

  _setMethod(method) {
    let methodInput = this.formEl.querySelector('input[name="_method"]')
    if (!methodInput) {
      methodInput = document.createElement("input")
      methodInput.type = "hidden"
      methodInput.name = "_method"
      this.formEl.appendChild(methodInput)
    }
    methodInput.value = method
  }

  clear(e) {
    if(e) e.preventDefault()
    if(confirm("すべて消去しますか？")) {
      this.pad.clear()
    }
  }

  switchToPen(e) {
    if(e) e.preventDefault()
    this.currentMode = 'pen'
    this.pad.activePen()
    this.pad.setLineWidth(this.penWidth)
    this.updateUI()
  }

  switchToEraser(e) {
    if(e) e.preventDefault()
    this.currentMode = 'eraser'
    this.pad.activeEraser()
    this.pad.setLineWidth(this.eraserWidth)
    this.updateUI()
  }

  changeSize(size) {
    this.pad.setLineWidth(size)
    if (this.currentMode === 'pen') {
      this.penWidth = size
    } else {
      this.eraserWidth = size
    }
    this.updateUI()
  }

  updateUI() {
    const activeToolClass = "p-2 rounded-full transition-all duration-200 bg-indigo-600 text-white shadow-md scale-110"
    const inactiveToolClass = "p-2 rounded-full transition-all duration-200 bg-transparent text-slate-400 hover:bg-slate-100"

    if (this.currentMode === 'pen') {
      this.penBtnEl.className = activeToolClass
      this.eraserBtnEl.className = inactiveToolClass
    } else {
      this.penBtnEl.className = inactiveToolClass
      this.eraserBtnEl.className = activeToolClass
    }

    const currentSize = (this.currentMode === 'pen') ? this.penWidth : this.eraserWidth
    this.sizeBtnEls.forEach(btn => {
      const size = parseInt(btn.dataset.size)
      if (size === currentSize) {
        btn.className = "w-8 h-8 rounded-full text-[10px] font-bold transition-all duration-200 bg-slate-800 text-white scale-110 shadow-md"
      } else {
        btn.className = "w-8 h-8 rounded-full text-[10px] font-bold transition-all duration-200 bg-slate-100 text-slate-400 hover:bg-slate-200"
      }
    })
  }

  resizeCanvas() {
    if (this.modalEl && !this.modalEl.classList.contains("hidden")) {
      this.canvasEl.width = window.innerWidth
      this.canvasEl.height = window.innerHeight
    }
  }
}