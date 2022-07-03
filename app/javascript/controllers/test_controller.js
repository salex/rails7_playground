import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "checkbox","display"]

  connect() {
    this.checkboxTargets[0].checked = true
    this.displayTargets[0].classList.remove('hidden')    // this.doSomething()
  }

  doSomething(){
    var idx = this.checkboxTargets.indexOf(event.target)
    this.displayTargets[idx].classList.toggle('hidden')
  }
}
