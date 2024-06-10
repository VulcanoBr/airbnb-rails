import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="stripe-payment"
export default class extends Controller {
  static values = { url: String }

  async connect() {
    const fetchClientSecret = async () => {
      const response = await post(this.urlValue)
      const { clientSecret } = await response.json
      return clientSecret
    } 

    let publishableKey = document.head.querySelector("meta[name='stripe-pk']").content
    const stripe = Stripe(publishableKey);
    
    this.checkout = await stripe.initEmbeddedCheckout({
      fetchClientSecret,
    });
  
    // Mount Checkout
    this.checkout.mount(this.element);
  }

  disconnect() {
    this.checkout.destroy()
  }
}
