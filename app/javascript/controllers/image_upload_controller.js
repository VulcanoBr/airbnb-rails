import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"
import { post } from "@rails/request.js"

// Connects to data-controller="image-upload"
export default class extends Controller {
  static targets = ["input", "preview"]
  static values = { url: String }
  fileAdded(e) {
    let files = Array.from(e.target.files)
    let directUploadUrl = e.target.dataset['directUploadUrl']
    files.forEach(file => {
      console.log("creating direct upload", file)
      let directUpload = new Uploader(file, directUploadUrl, this)
      directUpload.uploadFile(file)
    })
    e.target.value = "";
  }
}

class Uploader {
  constructor(file, url, controller) {
    this.file = file
    this.url = url
    this.controller = controller
    this.upload = new DirectUpload(this.file, this.url, this)
  }

  uploadFile(file) {
    this.upload.create(async (error, blob) => {

      if (error) {
        // Handle the error
      } else {
        console.log("File was uploaded", file)
        await post(this.controller.urlValue, {
          body: {
            blob_signed_id: blob.signed_id
          },
          responseKind: 'turbo-stream'
        })
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event))
  }

  directUploadDidProgress(event) {
    // Use event.loaded and event.total to update the progress bar
    console.log("Progress", event)
  }
}