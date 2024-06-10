import { Controller } from "@hotwired/stimulus"
import {loadConnectAndInitialize} from '@stripe/connect-js';
import { post } from "@rails/request.js"

// Connects to data-controller="stripe-onboarding"
export default class extends Controller {
  async connect() {
    let publishableKey = document.head.querySelector("meta[name='stripe-pk']").content
    const response = await post("/stripe/account_sessions")
    const jsonData = await response.json
    let clientSecret = jsonData['client_secret']
    console.log("Made reuqest client secret is", clientSecret)
    const stripeConnectInstance = loadConnectAndInitialize({
      // This is your test publishable API key.
      publishableKey: publishableKey,
      clientSecret: clientSecret,
    });
    const accountOnboarding = stripeConnectInstance.create("account-onboarding");
    this.element.innerHTML = ""
    this.element.appendChild(accountOnboarding)
  }
}
