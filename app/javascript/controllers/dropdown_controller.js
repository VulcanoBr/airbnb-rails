import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  toggle(e) {
    e.preventDefault()
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("hidden")
      this.menuTarget.style.opacity = "0%"
      setTimeout(() => {
        this.menuTarget.style.opacity = "100%"
      }, 50)
    } else {
      this.menuTarget.style.opacity = "0%"
      setTimeout(() => {
        this.menuTarget.classList.add("hidden")
        this.menuTarget.style.opacity = "100%"
      }, 100)
    }
  }

  closeUnlessDropdown(e) {
    if (!this.element.contains(e.target) && !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
