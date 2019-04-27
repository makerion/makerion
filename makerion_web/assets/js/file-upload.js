
class FileUploadHandler {
  constructor(formElement) {
    this.formElement = formElement
    this.formElement.onsubmit = this.uploadFile

    this.fileInput = formElement.querySelector('[type=file]')
    this.fileInput.onchange = this.fileChanged

    this.chooseFileButton = formElement.querySelector('[data-id=choose_file]')
    this.chooseFileButton.onclick = this.chooseFile

    this.fileNameField = formElement.querySelector('[data-id=file_name_field]')
  }

  fileChanged = (e) => {
    this.fileNameField.innerHTML = e.target.files[0].name
  }

  chooseFile = (e) => {
    this.fileInput.click()
  }

  uploadFile = (e) => {
    e.preventDefault()
    e.cancelBubble = true
    console.log("here uploadFile")

    const data = new FormData(this.formElement)
    this.postData(data)

    return false
  }

  postData = (data = {}) => {
    return window
      .fetch(`/api/print_files`, {
        method: "POST",
        // mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache",
        // credentials: "same-origin",
        headers: {
          // "Content-Type": "multipart/form-data"
          // "X-CSRF-Token": document.querySelector("meta[name=\"csrf-token\"]").getAttribute("content")
          "Accept": "application/json"
        },
        referrer: "no-referrer", // no-referrer, *client
        body: data
      })
      .then(response => response.json())
      .then((data) => {
        const statusElement = document.querySelector('[data-field-name="file"].status')
        if(data.status === "success") {
          statusElement.innerHTML = "File Uploaded Successfully"
          this.fileInput.value = '';
        } else {
          statusElement.innerHTML = `Path ${data.errors.path[0]}`
        }
      })
  }
}

window.addEventListener('DOMContentLoaded', (event) => {
  Array
    .from(document.querySelectorAll('.file-upload-form'))
    .map(element => new FileUploadHandler(element))
});
