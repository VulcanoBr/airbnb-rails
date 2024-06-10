import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="utils"
export default class extends Controller {
  remove(e) {
    e.preventDefault()
    this.element.remove()
  }
}
